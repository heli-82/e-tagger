extends Node

var database: SQLite

func connect_db() -> void:
	database = SQLite.new()
	database.path = "res://data.db"
	database.open_db()


func prepare_tables() -> void:
	connect_db()
	var img_table = {
		"img_id" : {"data_type":"int", "primary_key":true, "unique":true, "not_null":true, "auto_increment":true},
		"path" : {"data_type":"text", "unique":true, "not_null":true}
	}
	database.create_table("imgs", img_table)
	var tag_table = {
		"tag_id" : {"data_type":"int", "primary_key":true, "unique":true, "not_null":true, "auto_increment":true},
		"tag_name" : {"data_type":"text", "unique":true, "not_null":true},
		"color" : {"data_type":"text"}
	}
	database.create_table("tags", tag_table)
	var main_table_request: String = """CREATE TABLE IF NOT EXISTS main (
		attachment_id INTEGER PRIMARY KEY AUTOINCREMENT UNIQUE NOT NULL, 
		img_id INTEGER NOT NULL, 
		tag_id INTEGER NOT NULL, 
		UNIQUE (img_id, tag_id)
	)"""
	database.query(main_table_request)


#creates meta_imgs record if it not yet exists
func add_img(path: String) -> void:
	database.insert_row("imgs", {"path": path})

func attach_tag(path: String, tag: String) -> void:
	var tag_id: int = database.select_rows("tags", 'tag_name == "' + tag + '"', ["tag_id"])[0]["tag_id"]
	add_img(path)
	var img_id: int = database.select_rows("imgs", 'path == "' + path + '"', ["img_id"])[0]["img_id"]
	database.insert_row("main", {"tag_id": tag_id, "img_id": img_id})

func detach_tag(path: String, tag: String) -> void:
	var tag_id: int = database.select_rows("tags", 'tag_name == "' + tag + '"', ["tag_id"])[0]["tag_id"]
	var img_id: int = database.select_rows("imgs", 'path == "' + path + '"', ["img_id"])[0]["img_id"]
	print(tag_id, " ", img_id, " ", path)
	database.query("DELETE FROM main WHERE tag_id=" + str(tag_id) + " "+ "and img_id=" + str(img_id))
	#database.delete_rows("main", "where tag_id=%s and img_id=%s" % tag_id % img_id)


#creates meta_tags record if it not yet exists
func add_tag(tag_name: String, color: String = "#1d1d27") -> void:
	database.insert_row("tags", {"tag_name": tag_name, "color": color})


func get_imgs(tag: String) -> Array[String]:
	var tag_id: int = database.select_rows("tags", 'tag_name == "' + tag + '"', ["tag_id"])[0]["tag_id"]
	var img_ids: Array[Dictionary] = database.select_rows("main", 'tag_id = ' + '"'+str(tag_id)+'"', ["img_id"])
	var img_paths: Array[String] = []
	for img_id in img_ids:
		var path: String = database.select_rows("imgs", "img_id = "+str(img_id["img_id"]), ["path"])[0]["path"]
		img_paths.append(path)
	return img_paths

func less_than(a:Dictionary, b:Dictionary) -> bool:
	return a["tag_id"] < b["tag_id"]

func get_tags() -> Array[String]:
	var tags: Array[Dictionary] = database.select_rows("tags", "", ["tag_id", "tag_name"])
	tags.sort_custom(less_than)
	var tag_names: Array[String] = []
	for t in tags:
		tag_names.append(t["tag_name"])
	return tag_names


func _ready() -> void:
	prepare_tables()
