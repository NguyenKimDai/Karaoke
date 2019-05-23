package com.team7.karaokeapp.activity;

import android.os.Bundle;
import android.os.Handler;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.support.v7.widget.Toolbar;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;

import com.miguelcatalan.materialsearchview.MaterialSearchView;
import com.team7.karaokeapp.R;
import com.team7.karaokeapp.YoutubeConnector;
import com.team7.karaokeapp.adapter.YoutubeConectorAdapter;
import com.team7.karaokeapp.models.VideoItem;

import java.util.List;

public class SearchActivity extends AppCompatActivity {

    MaterialSearchView materialSearchView;
    String[] list;
    private RecyclerView videosFound;

    private Handler handler;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_search);

        Toolbar toolbar = findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);



        list = new String[]{"intro no music","karaoke","nonstop","n2","n3","Clipcodes", "Android Tutorials", "Youtube Clipcodes Tutorials", "SearchView Clicodes", "Android Clipcodes", "Tutorials Clipcodes"};

        materialSearchView = findViewById(R.id.mysearch);
        materialSearchView.clearFocus();
        materialSearchView.setSuggestions(list);

        materialSearchView.setOnQueryTextListener(new MaterialSearchView.OnQueryTextListener() {
            @Override
            public boolean onQueryTextSubmit(String query) {
                //Here Create your filtering

                Log.d("cuonghx", "onQueryTextSubmit: " + query);
                searchOnYoutube(query);
                return false;
            }

            @Override
            public boolean onQueryTextChange(String newText) {
                //You can make change realtime if you typing here
                //See my tutorials for filtering with ListView
                return false;
            }
        });


        videosFound = findViewById(R.id.videos_found);

        handler = new Handler();


    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu){
        getMenuInflater().inflate(R.menu.menu, menu);

        MenuItem item = menu.findItem(R.id.search);

        materialSearchView.setMenuItem(item);


        return true;
    }

    private List<VideoItem> searchResults;

    private void searchOnYoutube(final String keywords){
        new Thread(){
            public void run(){
                YoutubeConnector yc = new YoutubeConnector(SearchActivity.this);
                searchResults = yc.search(keywords);
                handler.post(new Runnable(){
                    public void run(){
                        updateVideosFound();
                    }
                });
            }
        }.start();
    }

    private void updateVideosFound(){
        YoutubeConectorAdapter youtubeConectorAdapter = new YoutubeConectorAdapter(searchResults,SearchActivity.this);
        videosFound.setAdapter(youtubeConectorAdapter);
        videosFound.setLayoutManager(new LinearLayoutManager(SearchActivity.this));
    }

}
