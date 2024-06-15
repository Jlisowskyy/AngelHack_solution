import moviepy.editor as mp
from mutagen.mp3 import MP3


_video_path = "video_storage/parkour.mp4"
_output_video_path = "video_storage/output.mp4"
_audio_path = "audio_storage/output.mp3"


def get_audio_length(audio_path):
    audio = MP3(audio_path)
    return audio.info.length


if __name__ == '__main__':
    audio_file_path = _audio_path
    video_file_path = _video_path
    output_video_path = _output_video_path

    # calculating audio length
    audio_length = get_audio_length(audio_file_path)

    # creating clip
    clip = mp.VideoFileClip(video_file_path).subclip(10, 10 + audio_length)

    # getting audioclip
    audioclip = mp.AudioFileClip(audio_file_path)
    finalclip = clip.set_audio(audioclip)
    finalclip.write_videofile(output_video_path)
