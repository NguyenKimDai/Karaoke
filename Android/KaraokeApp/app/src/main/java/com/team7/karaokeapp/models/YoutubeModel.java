package com.team7.karaokeapp.models;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by cuonghx on 3/4/2018.
 */

public class YoutubeModel {
    List<VideoItem> list;

    public YoutubeModel(){
        list = new ArrayList<>();
    }

    public List<VideoItem> getList() {
        if (list == null){
            list = new ArrayList<>();
        }
        return list;
    }

    public void setList(ArrayList<VideoItem> list) {
        this.list = list;
    }

    public YoutubeModel(ArrayList<VideoItem> list) {
        this.list = list;
    }
}
