
package com.example.heza_player_getx
import com.google.gson.JsonArray


data class MusicModalList( val id:String,val title:String, val albums:String, val artist:String, val duration:String , val path: String)
class FinaljList(var musicMymusic:List<MusicModalList>)