"use strict";
var audiostate = {};
var myAudio = new Audio();
myAudio.src = "scratch.mp3";

chrome.tabs.onUpdated.addListener(function(tabId, changeInfo, tab){
    if(tab.audible && tab.audible === true && (!tab.mutedInfo || tab.mutedInfo.muted === false)){
        audiostate[tabId] = true;
    }else{
        audiostate[tabId] = false;
    }
});

chrome.tabs.onRemoved.addListener(function(tabId, removeInfo){
    if(audiostate[tabId] === true){
        myAudio.play();
    }
});