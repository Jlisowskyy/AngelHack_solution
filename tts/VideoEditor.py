import moviepy.editor as mp
from mutagen.mp3 import MP3
from moviepy.editor import TextClip
from moviepy.video.tools.subtitles import SubtitlesClip
import configparser


class VideoEditor:
    def __init__(self, config_path):
        self.cnf = configparser.ConfigParser()
        self.cnf.read(config_path)

    def CreateShort(self):
        audio_file_path = self.cnf['TTS_CONFIG']['AUDIO_PATH']
        video_file_path = self.cnf['TTS_CONFIG']['VIDEO_PATH']
        output_video_path = self.cnf['TTS_CONFIG']['OUTPUT_PATH']
        subtitles_path = self.cnf['TTS_CONFIG']['SUBTITLES_PATH']
        offset = int(self.cnf['TTS_CONFIG']['OFFSET'])

        # calculating audio length
        audio_length = get_audio_length(audio_file_path)

        # creating clip
        clip = mp.VideoFileClip(video_file_path).subclip(offset, offset + audio_length)

        # str sub
        generator = lambda txt: TextClip(
            txt,
            font=self.cnf['TTS_CONFIG']['FONT_PATH'],
            fontsize=int(self.cnf['TTS_CONFIG']['FONT_SIZE']),
            color=self.cnf['TTS_CONFIG']['FONT_IN_COLOR'],
            stroke_color=self.cnf['TTS_CONFIG']['FONT_OUT_COLOR'],
            stroke_width=5, )
        subtitles = SubtitlesClip(subtitles_path, generator)

        # adding subtitles
        result = mp.CompositeVideoClip([
            clip,
            subtitles.set_pos(("center", "center"))
        ])

        # getting audio clip
        audioclip = mp.AudioFileClip(audio_file_path)
        finalclip = result.set_audio(audioclip)
        finalclip.write_videofile(output_video_path, fps=clip.fps)


def get_audio_length(audio_path):
    audio = MP3(audio_path)
    return audio.info.length


if __name__ == '__main__':
    ve = VideoEditor('config.ini')
    ve.CreateShort()
