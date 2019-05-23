package com.team7.karaokeapp;

import android.content.Context;
import android.util.Log;
import android.widget.Toast;

import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.database.DataSnapshot;
import com.google.firebase.database.DatabaseError;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;
import com.google.firebase.database.ValueEventListener;
import com.team7.karaokeapp.models.StatusModel;
import com.team7.karaokeapp.models.VideoItem;
import com.team7.karaokeapp.models.YoutubeModel;

/**
 * Created by cuonghx on 3/4/2018.
 */

public class Utils {
    private static FirebaseDatabase firebaseDatabase;
    private static DatabaseReference databaseReference;
    public  static String keyID ;

    public static void login(){
        FirebaseAuth.getInstance().signInWithEmailAndPassword("cuonghx2709@gmail.com","270919988");
    }
    public static void postId(final VideoItem videoItem){
        firebaseDatabase = FirebaseDatabase.getInstance();
        databaseReference = firebaseDatabase.getReference(keyID).child("YoutubeModel");

        databaseReference.addListenerForSingleValueEvent(new ValueEventListener() {
            @Override
            public void onDataChange(DataSnapshot dataSnapshot) {
                if (dataSnapshot.getChildrenCount() > 0){
                    for (DataSnapshot d : dataSnapshot.getChildren()){
                        YoutubeModel youtubeModel = d.getValue(YoutubeModel.class);

                        youtubeModel.getList().add(videoItem);

                        databaseReference.child(d.getKey()).setValue(youtubeModel);

                    }
                }else{
                    YoutubeModel youtubeModel = new YoutubeModel();
                    youtubeModel.getList().add(videoItem);

                    databaseReference.push().setValue(youtubeModel);

                    databaseReference = firebaseDatabase.getReference("Status");

                    databaseReference.addListenerForSingleValueEvent(new ValueEventListener() {
                        @Override
                        public void onDataChange(DataSnapshot dataSnapshot) {
                            if (dataSnapshot.getChildrenCount() > 0){
                                for (DataSnapshot d : dataSnapshot.getChildren()){
                                    StatusModel statusModel = d.getValue(StatusModel.class);
                                    if(statusModel.getStatus().equals("stop")) {
                                        statusModel.setStatus("next");
                                        databaseReference.child(d.getKey()).setValue(statusModel);
                                    }
                                }
                            }
                        }

                        @Override
                        public void onCancelled(DatabaseError databaseError) {

                        }
                    });
                }


            }

            @Override
            public void onCancelled(DatabaseError databaseError) {

            }
        });
    }
    public static void delete(final VideoItem videoItem){
        firebaseDatabase = FirebaseDatabase.getInstance();
        databaseReference = firebaseDatabase.getReference(keyID).child("YoutubeModel");

        databaseReference.addListenerForSingleValueEvent(new ValueEventListener() {
            @Override
            public void onDataChange(DataSnapshot dataSnapshot) {
                if (dataSnapshot.getChildrenCount() > 0){
                    for (DataSnapshot d : dataSnapshot.getChildren()){
                        YoutubeModel youtubeModel = d.getValue(YoutubeModel.class);
                        VideoItem delete = new VideoItem();

                        for (VideoItem v : youtubeModel.getList()){
                            if (v.getId() == videoItem.getId()){
                                delete =v;
                            }
                        }
                        youtubeModel.getList().remove(delete);

                        databaseReference.child(d.getKey()).setValue(youtubeModel);

                    }
                }
            }

            @Override
            public void onCancelled(DatabaseError databaseError) {

            }
        });
    }
    public static void putOnYop(final VideoItem videoItem){
        firebaseDatabase = FirebaseDatabase.getInstance();
        databaseReference = firebaseDatabase.getReference(keyID).child("YoutubeModel");

        databaseReference.addListenerForSingleValueEvent(new ValueEventListener() {
            @Override
            public void onDataChange(DataSnapshot dataSnapshot) {
                if (dataSnapshot.getChildrenCount() > 0){
                    for (DataSnapshot d : dataSnapshot.getChildren()){
                        YoutubeModel youtubeModel = d.getValue(YoutubeModel.class);
                        VideoItem delete = new VideoItem();
                        if(youtubeModel.getList().get(0).getId() != videoItem.getId()) {

                            for (VideoItem v : youtubeModel.getList()) {
                                if (v.getId() == videoItem.getId()) {
                                    delete = v;
                                }
                            }
                            youtubeModel.getList().remove(delete);
                            youtubeModel.getList().add(0, videoItem);

                            databaseReference.child(d.getKey()).setValue(youtubeModel);
                        }

                    }
                }
            }

            @Override
            public void onCancelled(DatabaseError databaseError) {

            }
        });
    }
    public static void updateStatusNext(final Context context){
        firebaseDatabase = FirebaseDatabase.getInstance();
        databaseReference = firebaseDatabase.getReference(keyID).child("Status");

        databaseReference.addListenerForSingleValueEvent(new ValueEventListener() {
            @Override
            public void onDataChange(DataSnapshot dataSnapshot) {
                if (dataSnapshot.getChildrenCount() > 0){
                    for (DataSnapshot d : dataSnapshot.getChildren()){
                        StatusModel statusModel = d.getValue(StatusModel.class);
                        if(statusModel.getStatus().equals("play")) {
                            statusModel.setStatus("next");
                            databaseReference.child(d.getKey()).setValue(statusModel);
                        }
                    }
                }else {
                    StatusModel statusModel = new StatusModel();
                    statusModel.setStatus("next");
                    databaseReference.push().setValue(statusModel);
                }
                Log.d("cuonghx", "onDataChange: ");
                Toast.makeText(context, "Xin chờ", Toast.LENGTH_SHORT).show();
            }

            @Override
            public void onCancelled(DatabaseError databaseError) {

            }
        });
    }
}
