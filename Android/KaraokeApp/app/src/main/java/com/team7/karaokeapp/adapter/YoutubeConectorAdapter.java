package com.team7.karaokeapp.adapter;

import android.content.Context;
import android.content.Intent;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import com.squareup.picasso.Picasso;
import com.team7.karaokeapp.R;
import com.team7.karaokeapp.Utils;
import com.team7.karaokeapp.activity.MainActivity;
import com.team7.karaokeapp.models.VideoItem;

import java.util.List;


/**
 * Created by cuonghx on 3/4/2018.
 */

public class YoutubeConectorAdapter extends RecyclerView.Adapter<YoutubeConectorAdapter.ViewHolderYoutube> {

    private List<VideoItem> list ;
    private Context context;

    public YoutubeConectorAdapter(List<VideoItem> list, Context context){
        this.list = list;
        this.context = context;
    }

    @Override
    public ViewHolderYoutube onCreateViewHolder(ViewGroup parent, int viewType) {
        LayoutInflater layoutInflater = LayoutInflater.from(parent.getContext());
        View itemView = layoutInflater.inflate(R.layout.items_layout, parent, false);
        return new ViewHolderYoutube(itemView);
    }

    @Override
    public void onBindViewHolder(ViewHolderYoutube holder, int position) {
        holder.loadData(list.get(position));
    }

    @Override
    public int getItemCount() {
        if(list == null){
            return 0;
        }
        return list.size();
    }

    public class ViewHolderYoutube extends RecyclerView.ViewHolder{

        TextView tvDesciption ;
        TextView tvTitle;
        ImageView ivImage;
        ImageView ivMore;
        View view;

        public ViewHolderYoutube(View itemView) {
            super(itemView);

            tvDesciption = itemView.findViewById(R.id.video_description);
            tvTitle = itemView.findViewById(R.id.video_title);
            ivImage = itemView.findViewById(R.id.video_thumbnail);
            ivMore = itemView.findViewById(R.id.iv_more);
            view = this.itemView;
        }
        public void loadData(final VideoItem videoItem){
            tvDesciption.setText(videoItem.getDescription());
            tvTitle.setText(videoItem.getTitle());
            Picasso.with(context).load(videoItem.getThumbnailURL()).into(ivImage);

            view.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    Utils.postId(videoItem);
                    Toast.makeText(context, "selected", Toast.LENGTH_SHORT).show();
                }
            });

            ivMore.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    Intent intent = new Intent(context, MainActivity.class);
                    intent.putExtra("VIDEO_ID", videoItem.getId());
                    context.startActivity(intent);
                }
            });
        }

    }
}
