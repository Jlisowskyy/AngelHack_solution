import assemblyai as aai
from typing import List
from moviepy.editor import *
from datetime import timedelta
import srt_equalizer
from moviepy.video.tools.subtitles import SubtitlesClip
import configparser
import elTTS


class SubtitleGenerator:
    def __init__(self, config_path):
        self.cnf = configparser.ConfigParser()
        self.cnf.read(config_path)

    @staticmethod
    def __generate_subtitles_assemblyai(audio_path: str, voice: str, assembly_api_key: str) -> str:
        language_mapping = {
            "br": "pt",
            "id": "en",  # AssemblyAI doesn't have Indonesian
            "jp": "ja",
            "kr": "ko",
        }

        if voice in language_mapping:
            lang_code = language_mapping[voice]
        else:
            lang_code = voice

        aai.settings.api_key = assembly_api_key
        config = aai.TranscriptionConfig(language_code=lang_code)
        transcriber = aai.Transcriber(config=config)
        transcript = transcriber.transcribe(audio_path)
        subtitles = transcript.export_subtitles_srt()

        return subtitles

    def generate_subtitles(self):
        def equalize_subtitles(srt_path: str, max_chars: int = 10) -> None:
            srt_equalizer.equalize_srt_file(srt_path, srt_path, max_chars)

        assembly_api_key = self.cnf['TTS_CONFIG']['ASSEMBLY_AI_API_KEY']
        if assembly_api_key is not None and assembly_api_key != "":
            subtitles = self.__generate_subtitles_assemblyai(self.cnf['TTS_CONFIG']['AUDIO_PATH'], "en",
                                                             assembly_api_key)
        else:
            print("[-] Local subtitle generation has been disabled for the time being.")
            print("[-] Exiting.")
            sys.exit(1)

        with open(self.cnf['TTS_CONFIG']['SUBTITLES_PATH'], "w") as file:
            file.write(subtitles)
        equalize_subtitles(self.cnf['TTS_CONFIG']['SUBTITLES_PATH'])


if __name__ == '__main__':
    sg = SubtitleGenerator('config.ini')
    sg.generate_subtitles()
