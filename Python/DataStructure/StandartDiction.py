# -*- coding: utf-8 -*-
"""
Created on Fri Jul 19 09:33:54 2019

@author: semen
"""
class city:
    def __init__(self):
        self.Storage= dict()

    def addCity(self, keyID, distance):
        if not(keyID in self.Storage):
            self.Storage[keyID]=distance
        else:
            if(self.Storage[keyID]>distance):
                self.Storage[keyID]=distance

    def PrintCity(self):
        ordlist = sorted(self.Storage.items(), key=lambda kv: kv[1])
        for i in ordlist:
            print (i[0])