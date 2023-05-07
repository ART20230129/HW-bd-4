--количество исполнителей в каждом жанре
SELECT name_genre, count(executor_id) FROM music_genre mg
JOIN performer_different_genres pdg ON mg.genre_id = pdg.genre_id 
GROUP BY mg.name_genre 
ORDER BY count(executor_id);

--количество треков, вошедших в альбомы 2019–2020 годов
SELECT name_album, count(name_album) FROM album_list al 
JOIN track_list tl ON al.album_id = tl.album_id 
WHERE year_publiction BETWEEN 2019 AND 2020
GROUP BY name_album;

--cредняя продолжительность треков по каждому альбому
SELECT name_album, avg(track_duration) FROM album_list al  
JOIN track_list tl ON al.album_id = tl.album_id 
GROUP BY name_album;

--все исполнители, которые не выпустили альбомы в 2020 году
SELECT name_executor, year_publiction FROM music_executor me
JOIN executor_ft_executor efe ON me.executor_id = efe.executor_id  
JOIN album_list al ON efe.album_id = al.album_id 
WHERE year_publiction != 2020;

--названия сборников, в которых присутствует конкретный исполнитель (выберите его сами- ABBA)
SELECT c.name_collection FROM collection_track c 
JOIN track_collection tc ON c.collection_id = tc.collection_id 
JOIN track_list tl ON tc.track_id = tl.track_id 
JOIN album_list al ON tl.album_id = al.album_id 
JOIN executor_ft_executor efe ON al.album_id = efe.album_id  
JOIN music_executor me ON efe.executor_id = me.executor_id 
WHERE me.name_executor = 'ABBA'; 

--Названия альбомов, в которых присутствуют исполнители более чем одного жанра
SELECT name_album, count(name_genre) FROM album_list al 
JOIN executor_ft_executor efe ON al.album_id = efe.album_id 
JOIN music_executor me ON efe.executor_id = me.executor_id 
JOIN performer_different_genres pdg ON me.executor_id  = pdg.executor_id 
JOIN music_genre mg ON pdg.genre_id = mg.genre_id 
GROUP BY name_album 
HAVING count(name_genre) > 1;

--Наименования треков, которые не входят в сборники
SELECT name_track FROM track_list tl 
FULL OUTER JOIN track_collection tc ON tl.track_id = tc.track_id 
LEFT JOIN collection_track ct ON tc.collection_id = ct.collection_id 
WHERE ct.collection_id IS NULL;

--Исполнитель или исполнители, написавшие самый короткий по продолжительности трек
SELECT me.name_executor, tl.track_duration FROM music_executor me 
JOIN executor_ft_executor efe ON me.executor_id = efe.executor_id 
JOIN album_list al ON efe.album_id = al.album_id 
JOIN track_list tl ON al.album_id = tl.album_id 
WHERE tl.track_duration = (SELECT min(track_duration) FROM track_list);

--Названия альбомов, содержащих наименьшее количество треков
SELECT al.name_album, count(tl.name_track) FROM album_list al 
JOIN track_list tl ON al.album_id = tl.album_id 
GROUP BY al.name_album
HAVING count(tl.name_track) = (
	SELECT min(count) FROM (
		SELECT al.name_album, count(tl.name_track) FROM album_list al
		JOIN track_list tl ON al.album_id = tl.album_id 
		GROUP BY al.name_album) AS foo


);

