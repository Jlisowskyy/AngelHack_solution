from app import create_app, db
#from app.models import User

# print what is the current working directory
import os
print(os.getcwd())

exit()

app = create_app()

@app.shell_context_processor
def make_shell_context():
    return {'db': db, 'User': User}

if __name__ == '__main__':
    app.run()
