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


#creates meta_tags record if it not yet exists
func add_tag(tag_name: String, color: String = "#1d1d27") -> void:
	database.insert_row("tags", {"tag_name": tag_name, "color": color})


func load_imgs(tag: String) -> void:
	var tag_id: int = database.select_rows("tags", 'tag_name == "' + tag + '"', ["tag_id"])[0]["tag_id"]
	var img_ids: Array[Dictionary] = database.select_rows("main", 'tag_id = ' + '"'+str(tag_id)+'"', ["img_id"])
	print(img_ids)
	for img_id in img_ids:
		var path: String = database.select_rows("imgs", "img_id = "+str(img_id["img_id"]), ["path"])[0]["path"]
		print(path)


func load_tags() -> void:
	var tags: Array[Dictionary] = database.select_rows("tags", "", ["tag_name"])
	print(tags)


func _ready() -> void:
	prepare_tables()
	load_imgs("sus")
	load_tags()
