import VideoEditor
import SubtitleGenerator
import elTTS


class ShortWrapper:
    @staticmethod
    def CreateShort(config_path):
        # text to speach
        tts = elTTS.TTS(config_path)
        tts.generate()

        # creating subtitles in srt format
        subtitle_generator = SubtitleGenerator.SubtitleGenerator(config_path)
        subtitle_generator.generate_subtitles()

        # creating the video
        video_editor = VideoEditor.VideoEditor(config_path)
        video_editor.CreateShort()


if __name__ == '__main__':
    ShortWrapper.CreateShort('config.ini')
