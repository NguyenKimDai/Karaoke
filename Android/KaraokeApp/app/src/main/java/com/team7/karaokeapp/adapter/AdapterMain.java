package com.team7.karaokeapp.adapter;

import android.content.Context;
import android.content.Intent;
import android.support.v7.widget.PopupMenu;
import android.support.v7.widget.RecyclerView;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.MenuItem;
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
 * Created by cuonghx on 3/5/2018.
 */

public class AdapterMain extends RecyclerView.Adapter<AdapterMain.ViewHolderMain> {

    private List<VideoItem> list ;
    private Context context;

    public AdapterMain(List<VideoItem> list, Context context){
        this.list = list;
        this.context = context;
    }

    @Override
    public AdapterMain.ViewHolderMain onCreateViewHolder(ViewGroup parent, int viewType) {
        LayoutInflater layoutInflater = LayoutInflater.from(parent.getContext());
        View itemView = layoutInflater.inflate(R.layout.items_main, parent, false);
        return new ViewHolderMain(itemView);
    }

    @Override
    public void onBindViewHolder(ViewHolderMain holder, int position) {
        holder.loadData(list.get(position));
    }

    @Override
    public int getItemCount() {
        if(list == null){
            return 0;
        }
        return list.size();
    }

    public class ViewHolderMain extends RecyclerView.ViewHolder{

        TextView tvDesciption ;
        TextView tvTitle;
        ImageView ivImage;
        View view;

        public ViewHolderMain(View itemView) {
            super(itemView);

            tvDesciption = itemView.findViewById(R.id.video_description);
            tvTitle = itemView.findViewById(R.id.video_title);
            ivImage = itemView.findViewById(R.id.video_thumbnail);
//            ivMore = itemView.findViewById(R.id.iv_more);
            view = this.itemView;
        }
        public void loadData(final VideoItem videoItem){
            tvDesciption.setText(videoItem.getDescription());
            tvTitle.setText(videoItem.getTitle());
            Picasso.with(context).load(videoItem.getThumbnailURL()).into(ivImage);

            view.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    PopupMenu popup = new PopupMenu(context, tvTitle);
                    //Inflating the Popup using xml file
                    popup.getMenuInflater()
                            .inflate(R.menu.menu_pop, popup.getMenu());

                    //registering popup with OnMenuItemClickListener
                    popup.setOnMenuItemClickListener(new PopupMenu.OnMenuItemClickListener() {
                        public boolean onMenuItemClick(MenuItem item) {

                            switch (item.getItemId()){
                                case R.id.one:
                                    Intent intent = new Intent(context, MainActivity.class);
                                    intent.putExtra("VIDEO_ID", videoItem.getId());
                                    context.startActivity(intent);
                                    Toast.makeText(context,
                                            "Xem thử: " + videoItem.getTitle(), Toast.LENGTH_SHORT
                                    ).show();
                                    break;
                                case R.id.two:
                                    Utils.putOnYop(videoItem);
                                    Toast.makeText(context,
                                            "Hát trước: " + videoItem.getTitle(), Toast.LENGTH_SHORT
                                    ).show();
                                    break;
                                case R.id.three:
                                    Utils.delete(videoItem);
                                    Toast.makeText(context,
                                            "Xóa: " + videoItem.getTitle(), Toast.LENGTH_SHORT
                                    ).show();
                                    Log.d("cuonghx", "onMenuItemClick: " + "xoa");
                                    break;
                            }

                            return true;
                        }
                    });

                    popup.show();
                }
            });
        }

    }
}
