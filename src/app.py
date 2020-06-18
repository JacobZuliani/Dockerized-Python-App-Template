from logger import get_logger



def app():

    logger.info("printing hello world")
    print("hello world")


if __name__ == "__main__":

    logger = get_logger()
    app()
