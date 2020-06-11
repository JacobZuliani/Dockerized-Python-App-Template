""" Sets up the logging system.
"""
import os
import sys
import logging
import watchtower

LOG_FORMAT = (
    "[%(asctime)s] [%(name)s,%(funcName)s:%(lineno)s] [%(levelname)s]  %(message)s"
)
DATE_FORMAT = "%d/%b/%Y %I:%M %p"


def get_logger():
    """
    Initializes the approiate logger using the environment variable "RUNTIME_ENV".
    This environment variable is set to PROD by default and is overwritten to be "DEV" by the
    docker-run task when the debug configuration "Docker: Python - General" is run.
    If the RUNTIME_ENV == PROD:
        The logger is initialized with the watchtower handler so that any logs recorded using the
        returned logger are sent to cloudWatch.
    If it is RUNTIME_ENV != PROD:
        I assume the program is being run in development or testing where I do not want logs to be
        sent to CloudWatch.

    Returns:
        logging.logger
    """
    logging.basicConfig(format=LOG_FORMAT, datefmt=DATE_FORMAT, level=logging.DEBUG)
    logger = logging.getLogger("app_name")

    if os.environ["RUNTIME_ENV"] == "PROD":

        watchtower_log_handler = watchtower.CloudWatchLogHandler()
        # setting a new handler resets the format to default, this is why I specify it again here
        watchtower_log_handler.setFormatter(
            logging.Formatter(LOG_FORMAT, datefmt=DATE_FORMAT)
        )
        logger.addHandler(watchtower_log_handler)
        # overwrite the default excepthook function so uncaught exceptions are sent to cloudWatch
        sys.excepthook = lambda exc_type, exc_value, exc_traceback: logger.critical(
            "Uncaught exception", exc_info=(exc_type, exc_value, exc_traceback)
        )
    return logger
