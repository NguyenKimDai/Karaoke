var done = false;
var config = {
    apiKey: "AIzaSyDdZTEhDJXkaxqEGFyA34yXO7gAYTfvmV4",
    authDomain: "cuonghxproject.firebaseapp.com",
    databaseURL: "https://cuonghxproject.firebaseio.com",
    projectId: "cuonghxproject",
    storageBucket: "cuonghxproject.appspot.com",
    messagingSenderId: "1006248249179"
};
firebase.initializeApp(config);
var database = firebase.database();
var keyID;

let listenStatus = () => {
    console.log("cuonghx");
    database.ref(keyID).child("Status").on('child_changed', function (data) {
        console.log("changed");
        let obj = data.val();
        if(obj.status == "next" && done){
            obj.status = "play";
            console.log("next");
            database.ref(keyID).child("Status/" + data.key).set(obj);
            nextSong();
            clearInterval(checkInt);
        }
    });
};

$(document).ready(() => {
    getKey();
});

let getKey = () => {
    database.ref().once("value", function (snapshot) {
        var idKey = 1
        snapshot.forEach(function (child) {
            idKey += 1
        })
        keyID = idKey
        // alert("Nhập key để kết nối đến màn hình này: Key của bạn là: " + keyID);
        $('body').append("<div class='modal'><div class='key'><span>Nhập key để kết nối đến màn hình</span><span class='center'>Key của bạn là: <span class='blue'>"+ keyID +"</span></span><span class='btn btn_primary btn_click'>OK</span></div></div>");
        checkStatus()
        nextSong();
        listenStatus();
    })
}

let checkStatus = () => {
    database.ref(keyID).child("Status").once("value", function (snapshot) {
        if (snapshot.numChildren() == 0)  {
            database.ref(keyID).child("Status").push({
                status : "play"
            })
        } else {
            snapshot.forEach(function (child) {
                let obj = child.val();
                if(obj.status == "next"){
                    obj.status = "play";
                    console.log("next");
                    database.ref(keyID).child("Status/" + child.key).set(obj);
                }
                // onPlayerStateChange()
            });
        }
    })
}

var tag = document.createElement('script');

tag.src = "https://www.youtube.com/iframe_api";
var firstScriptTag = document.getElementsByTagName('script')[0];
firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);

var player;
function onYouTubeIframeAPIReady(id) {
    player = new YT.Player('player', {
        videoId: 'EwuyNZDojg8',
        startSeconds: 1,
        events: {
            'onReady': onPlayerReady,
            'onStateChange': onPlayerStateChange,
            'onError' : onFail
        }
    });
}

function onFail() {
    nextSong()
}

window.onload = maxWindow;

function maxWindow() {
    window.moveTo(0, 0);


    if (document.all) {
        top.window.resizeTo(screen.availWidth, screen.availHeight);
    }

    else if (document.layers || document.getElementById) {
        if (top.window.outerHeight < screen.availHeight || top.window.outerWidth < screen.availWidth) {
            top.window.outerHeight = screen.availHeight;
            top.window.outerWidth = screen.availWidth;
        }
    }
}

function onPlayerReady(event) {
    event.target.playVideo();
    console.log("abcd")
}

let checkInt;
function onPlayerStateChange(event) {
    // console.log("ook");
    if (event.data == YT.PlayerState.PLAYING && !done) {
        done = true;
        checkInt = setInterval(() => {
            // console.log(player.getCurrentTime());
            // console.log(player.getDuration());

            if (player.getCurrentTime() >= player.getDuration()) {
                nextSong();
                clearInterval(checkInt);
    
            }
        }, 1000);

    }

}

let nextSong = () => {
    done = false;
    database.ref(keyID).child("YoutubeModel").once("value", function (snapshot) {
        if (snapshot.numChildren() == 0) {
            nextbyID({
                id : "EwuyNZDojg8",
                thumbnailURL : "https://i.ytimg.com/vi/-f-VQLkxZ2w/hqdefault.jpg",
                title : "[Vietsub][HD] Endless Love (The Myth Theme Song) - Jackie Chan & Kim Hee Sun"
            });
        } else {
            snapshot.forEach(function (child) {
                let obj = child.val();
                console.log(obj)
                let song = obj.list.shift();
                database.ref(keyID).child("YoutubeModel/" + child.key).set(obj);
                nextbyID(song);
                // onPlayerStateChange()
            });
        }
    });
};

let nextbyID = (song) => {
    player.loadVideoById(song.id, 0, "default");
    database.ref(keyID).child("Current").child("song").set({
        title : song.title,
        urlImage : song.thumbnailURL
    })
    // playFullscreen();
    // $('.ytp-fullscreen-button').focus();
}

function playFullscreen() {
    console.log("full");
    var el = document.documentElement
        , rfs = // for newer Webkit and Firefox
            el.requestFullScreen
            || el.webkitRequestFullScreen
            || el.mozRequestFullScreen
            || el.msRequestFullScreen
        ;
    if (typeof rfs != "undefined" && rfs) {
        rfs.call(el);
    } else if (typeof window.ActiveXObject != "undefined") {
        // for Internet Explorer
        var wscript = new ActiveXObject("WScript.Shell");
        if (wscript != null) {
            wscript.SendKeys("{F11}");
        }
    }
}
$(document).ready(function() {
    $('body').delegate('.btn_click', 'click', function(event) {
        $('.modal').css('display', 'none');
    });
});