from logger import get_logger



def app():

    logger.debug("printing hello world")
    print("hello world")


if __name__ == "__main__":

    logger = get_logger()
    app()
