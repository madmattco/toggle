
import logging
import os

class Event:

    def __init__(self, evt_type, payload):
        self.evt_type = evt_type
        self.payload = payload    

    def execute(self, config):
        logging.info("Executing event '"+str(self.evt_type)+"'")
        if self.evt_type == "FileSelected":
            logging.debug("Selected "+self.payload["filename"])
            filename = os.path.splitext(self.payload["filename"])[0]+".stl"
            config.loader.select_model(filename)
        if self.evt_type == "FileDeselected":
            logging.debug("Deselected "+self.payload["filename"])
            filename = os.path.splitext(self.payload["filename"])[0]+".stl"
            #config.loader.select_model(filename)
        elif self.evt_type == "Upload":
            logging.debug("Upload evt")
            config.loader.load_models()
        elif self.evt_type == "Disconnected":
            logging.debug("Printer Disconnected")
        elif self.evt_type == "Connected":
            logging.debug("Printer Connected")
