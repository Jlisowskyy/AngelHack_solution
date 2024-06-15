from elevenlabs import save
from elevenlabs.client import ElevenLabs
import configparser


class TTS(object):
    def __init__(self):
        self.cnf = configparser.ConfigParser()
        self.cnf.read('config.ini')

    def generate(self, text_filepath):
        # read file
        with open(text_filepath, 'r') as file:
            flashcard = file.read()

        # opening client
        client = ElevenLabs(
            api_key=self.cnf['TTS_CONFIG']['ELEVENLABS_API_KEY']  # Defaults to ELEVEN_API_KEY
        )

        # generate audio
        audio = client.generate(
            text=flashcard,
            voice="Antoni",
            model="eleven_multilingual_v2"
        )

        # Save audio to MP3
        output_filename = 'audio_storage/output.mp3'
        save(audio, output_filename)

    @staticmethod
    def generate_sentence(output_filename, sentence, cnf):
        # opening client
        client = ElevenLabs(
            api_key=cnf['TTS_CONFIG']['ELEVENLABS_API_KEY']  # Defaults to ELEVEN_API_KEY
        )

        # generate audio
        audio = client.generate(
            text=sentence,
            voice="Antoni",
            model="eleven_multilingual_v2"
        )

        # Save audio to MP3
        save(audio, output_filename)


if __name__ == '__main__':
    tts = TTS()
    tts.generate("example_flashcard.txt")

