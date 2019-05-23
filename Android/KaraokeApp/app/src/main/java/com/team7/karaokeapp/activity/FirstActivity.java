package com.team7.karaokeapp.activity;

import android.app.Dialog;
import android.content.Intent;
import android.graphics.Color;
import android.os.Bundle;
import android.support.design.widget.FloatingActionButton;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.support.v7.widget.Toolbar;
import android.util.Log;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.widget.EditText;

import com.google.firebase.database.DataSnapshot;
import com.google.firebase.database.DatabaseError;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;
import com.google.firebase.database.ValueEventListener;
import com.team7.karaokeapp.R;
import com.team7.karaokeapp.Utils;
import com.team7.karaokeapp.adapter.AdapterMain;
import com.team7.karaokeapp.models.VideoItem;
import com.team7.karaokeapp.models.YoutubeModel;

import java.util.ArrayList;

public class FirstActivity extends AppCompatActivity {

    DatabaseReference databaseReference ;
    FirebaseDatabase firebaseDatabase;

    AdapterMain adapterMain;
    RecyclerView recyclerView;
    FloatingActionButton floatingActionButton;
    EditText editText;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_first);

        Utils.login();

        recyclerView = findViewById(R.id.recycleview_main);
        floatingActionButton = findViewById(R.id.floatingbutton);

        floatingActionButton.setBackgroundColor(Color.parseColor("#d9d9d9"));

        floatingActionButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Utils.updateStatusNext(FirstActivity.this);
            }
        });


        Toolbar toolbar = findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);

        final Dialog dialog = new Dialog(this);

        dialog.setContentView(R.layout.custom_dialog);
        dialog.setTitle("Nhập Key để kết nối ");

        editText =  dialog.findViewById(R.id.editText);
        dialog.findViewById(R.id.save).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Utils.keyID = editText.getText().toString();
                firebaseDatabase = FirebaseDatabase.getInstance();
                databaseReference = firebaseDatabase.getReference(Utils.keyID).child("YoutubeModel");

                databaseReference.addValueEventListener(new ValueEventListener() {
                    @Override
                    public void onDataChange(DataSnapshot dataSnapshot) {
                        if (dataSnapshot.getChildrenCount() > 0){
                            for (DataSnapshot d : dataSnapshot.getChildren()){
                                YoutubeModel youtubeModel = d.getValue(YoutubeModel.class);
                                adapterMain = new AdapterMain(youtubeModel.getList(), FirstActivity.this);
                                recyclerView.setAdapter(adapterMain);
                                recyclerView.setLayoutManager(new LinearLayoutManager(FirstActivity.this));
                            }
                        }else {
                            adapterMain = new AdapterMain(new ArrayList<VideoItem>(), FirstActivity.this);
                            recyclerView.setAdapter(adapterMain);
                            recyclerView.setLayoutManager(new LinearLayoutManager(FirstActivity.this));
                        }
                    }

                    @Override
                    public void onCancelled(DatabaseError databaseError) {

                    }
                });
                dialog.cancel();
            }
        });
        dialog.findViewById(R.id.cancel).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Utils.keyID = editText.getText().toString();
                dialog.cancel();
            }
        });

        dialog.show();

        Log.d("cuonghx", "onStart: ");

    }

    @Override
    protected void onStart() {
        super.onStart();

    }



    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        int id = item.getItemId();
        if (id == R.id.search){
            Intent intent = new Intent(this, SearchActivity.class);
            startActivity(intent);
            return true;
        }
        return super.onOptionsItemSelected(item);
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        MenuInflater inflater = getMenuInflater();
        inflater.inflate(R.menu.menu, menu);
        return super.onCreateOptionsMenu(menu);
    }
}
