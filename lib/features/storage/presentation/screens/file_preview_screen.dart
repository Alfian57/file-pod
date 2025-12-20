import 'package:file_pod/features/storage/domain/entities/file_entity.dart';
import 'package:file_pod/features/storage/presentation/controllers/storage_controller.dart';
import 'package:file_pod/features/storage/presentation/services/file_download_service.dart';
import 'package:file_pod/features/storage/presentation/widgets/dialogs/delete_file_dialog.dart';
import 'package:file_pod/features/storage/presentation/widgets/dialogs/rename_dialog.dart';
import 'package:file_pod/features/storage/presentation/widgets/dialogs/share_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class FilePreviewScreen extends ConsumerStatefulWidget {
  const FilePreviewScreen({super.key, required this.file});

  final FileEntity file;

  @override
  ConsumerState<FilePreviewScreen> createState() => _FilePreviewScreenState();
}

class _FilePreviewScreenState extends ConsumerState<FilePreviewScreen> {
  late FileEntity _currentFile;
  late String _url;
  
  // Players
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;
  AudioPlayer? _audioPlayer;

  @override
  void initState() {
    super.initState();
    _currentFile = widget.file;
    _setupUrl();
  }

  void _setupUrl() {
    final baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost:8080';
    final cleanBase = baseUrl.endsWith('/')
        ? baseUrl.substring(0, baseUrl.length - 1)
        : baseUrl;
    _url = '$cleanBase/media/${_currentFile.filename}';
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _chewieController?.dispose();
    _audioPlayer?.dispose();
    super.dispose();
  }

  Future<void> _handleRename() async {
    final newName = await RenameDialog.show(
      context: context,
      currentName: _currentFile.originalName,
      type: 'File',
    );

    if (!mounted || newName == null || newName == _currentFile.originalName) return;

    await ref.read(storageControllerProvider.notifier).renameFile(_currentFile.id, newName);
    
    // Refresh storage list in background
    ref.read(storageControllerProvider.notifier).getStorage();
    if (ref.read(storageControllerProvider).currentFolderId != null) {
        ref.read(storageControllerProvider.notifier).getStorageDetail(ref.read(storageControllerProvider).currentFolderId!);
    }

    setState(() {
      _currentFile = FileEntity(
        id: _currentFile.id,
        filename: _currentFile.filename, // MinIO filename usually doesn't change on rename (only metadata)
        originalName: newName,
        mimeType: _currentFile.mimeType,
        sizeBytes: _currentFile.sizeBytes,
        createdAt: _currentFile.createdAt,

      );
    });
  }

  Future<void> _handleShare() async {
     final password = await ShareDialog.show(
      context: context,
      title: 'Share File',
    );

    if (!mounted || password == null) return;

    final shareResponse = await ref
        .read(storageControllerProvider.notifier)
        .shareFile(_currentFile.id, password.isEmpty ? null : password);

    if (!mounted) return;

    if (shareResponse != null) {
      ShareDialog.showShareResult(
        context: context,
        shareUrl: shareResponse.shareUrl,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to share file')),
      );
    }
  }

  Future<void> _handleDelete() async {
    await DeleteFileDialog.show(
      context: context,
      ref: ref,
      fileId: _currentFile.id,
      fileName: _currentFile.originalName,
      onSuccess: () {
        ref.read(storageControllerProvider.notifier).getStorage();
        if (ref.read(storageControllerProvider).currentFolderId != null) {
            ref.read(storageControllerProvider.notifier).getStorageDetail(ref.read(storageControllerProvider).currentFolderId!);
        }
        Navigator.pop(context); // Close preview
      },
    );
  }

  Future<void> _handleDownload() async {
     await FileDownloadService.downloadFile(
      context: context,
      ref: ref,
      fileId: _currentFile.id,
      fileName: _currentFile.originalName,
    );
  }

  @override
  Widget build(BuildContext context) {
    final extension = _currentFile.originalName.split('.').last.toLowerCase();
    
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.5),
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(_currentFile.originalName, style: const TextStyle(color: Colors.white)),
        actions: [
            IconButton(icon: const Icon(Icons.edit), onPressed: _handleRename),
            IconButton(icon: const Icon(Icons.share), onPressed: _handleShare),
            IconButton(icon: const Icon(Icons.download), onPressed: _handleDownload),
            IconButton(icon: const Icon(Icons.delete), onPressed: _handleDelete),
        ],
      ),
      body: Center(
        child: _buildPreview(extension),
      ),
    );
  }

  Widget _buildPreview(String extension) {
    if (['jpg', 'jpeg', 'png', 'gif', 'webp', 'bmp'].contains(extension)) {
        return InteractiveViewer(
            child: Image.network(
                _url,
                loadingBuilder: (ctx, child, progress) {
                    if (progress == null) return child;
                    return const CircularProgressIndicator(color: Colors.white);
                },
                errorBuilder: (ctx, error, stack) => const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                         Icon(Icons.broken_image, color: Colors.white, size: 50),
                         Text('Failed to load image', style: TextStyle(color: Colors.white)),
                    ],
                ),
            ),
        );
    } else if (['mp4', 'avi', 'mov', 'mkv', 'webm'].contains(extension)) {
        return _VideoPlayerWidget(url: _url);
    } else if (['mp3', 'wav', 'aac', 'm4a', 'flac'].contains(extension)) {
        return _AudioPlayerWidget(url: _url, title: _currentFile.originalName);
    } else {
        return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
                const Icon(Icons.insert_drive_file, color: Colors.white, size: 80),
                const SizedBox(height: 20),
                Text('No preview available for .$extension files', style: const TextStyle(color: Colors.white)),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                    onPressed: _handleDownload, 
                    icon: const Icon(Icons.download),
                    label: const Text('Download to View'),
                ),
            ],
        );
    }
  }
}

// Reuse video/audio widgets logic from handler but simplified as inner widgets or separate
class _VideoPlayerWidget extends StatefulWidget {
    final String url;
    const _VideoPlayerWidget({required this.url});

    @override
    State<_VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<_VideoPlayerWidget> {
    late VideoPlayerController _vc;
    ChewieController? _cc;
    
    @override
    void initState() {
        super.initState();
        _vc = VideoPlayerController.networkUrl(Uri.parse(widget.url))..initialize().then((_) {
            setState(() {
                _cc = ChewieController(
                    videoPlayerController: _vc,
                    autoPlay: true,
                    looping: false,
                );
            });
        });
    }

    @override
    void dispose() {
        _vc.dispose();
        _cc?.dispose();
        super.dispose();
    }

    @override
    Widget build(BuildContext context) {
        if (_cc != null && _vc.value.isInitialized) {
            return AspectRatio(
                aspectRatio: _vc.value.aspectRatio,
                child: Chewie(controller: _cc!),
            );
        }
        return const CircularProgressIndicator(color: Colors.white);
    }
}

class _AudioPlayerWidget extends StatefulWidget {
   final String url;
   final String title;
   const _AudioPlayerWidget({required this.url, required this.title});

   @override
   State<_AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<_AudioPlayerWidget> {
    final _player = AudioPlayer();
    
    @override
    void initState() {
        super.initState();
        _player.setUrl(widget.url);
    }

    @override
    void dispose() {
        _player.dispose();
        super.dispose();
    }

    String _formatDuration(Duration? duration) {
        if (duration == null) return '--:--';
        final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
        final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
        return '$minutes:$seconds';
    }

    @override
    Widget build(BuildContext context) {
        return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white10),
            ),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                    Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                            color: Colors.blueGrey.shade800,
                            shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.music_note, color: Colors.white, size: 40),
                    ),
                    const SizedBox(height: 20),
                    Text(
                        widget.title,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, 
                            color: Colors.white,
                            fontSize: 16
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 20),
                    StreamBuilder<Duration>(
                        stream: _player.positionStream,
                        builder: (context, snapshot) {
                            final position = snapshot.data ?? Duration.zero;
                            final duration = _player.duration ?? Duration.zero;
                            return Column(
                                children: [
                                    SliderTheme(
                                        data: SliderTheme.of(context).copyWith(
                                            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                                            overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
                                            trackHeight: 4,
                                            activeTrackColor: Colors.blueAccent,
                                            inactiveTrackColor: Colors.grey.shade800,
                                            thumbColor: Colors.white,
                                        ),
                                        child: Slider(
                                            value: position.inSeconds.toDouble().clamp(0, duration.inSeconds.toDouble()),
                                            max: duration.inSeconds.toDouble() > 0 ? duration.inSeconds.toDouble() : 1,
                                            onChanged: (value) {
                                                _player.seek(Duration(seconds: value.toInt()));
                                            },
                                        ),
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 10),
                                        child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                                Text(_formatDuration(position), style: const TextStyle(color: Colors.grey, fontSize: 12)),
                                                Text(_formatDuration(duration), style: const TextStyle(color: Colors.grey, fontSize: 12)),
                                            ],
                                        ),
                                    ),
                                ],
                            );
                        }
                    ),
                    const SizedBox(height: 10),
                    StreamBuilder<PlayerState>(
                        stream: _player.playerStateStream,
                        builder: (context, snapshot) {
                            final state = snapshot.data;
                            final playing = state?.playing ?? false;
                            final processingState = state?.processingState;
                            
                            if (processingState == ProcessingState.loading || processingState == ProcessingState.buffering) {
                                return const CircularProgressIndicator(color: Colors.white);
                            }

                            return Container(
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                    iconSize: 32,
                                    icon: Icon(playing ? Icons.pause : Icons.play_arrow),
                                    color: Colors.black,
                                    onPressed: () {
                                        if (playing) _player.pause();
                                        else _player.play();
                                    },
                                ),
                            );
                        },
                    ),
                ],
            ),
        );
    }
}
