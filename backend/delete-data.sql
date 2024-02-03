DELETE
FROM attendancerecord;

DELETE
FROM device;

DELETE
FROM event_tb_user;

DELETE
FROM location;

DELETE
FROM ticketrequest;

DELETE
FROM userfacephoto;

DELETE
FROM point;

DELETE
FROM pointrecord_factors;

DELETE
FROM pointrecord;

DELETE
FROM event;

DELETE
FROM tb_user;

SELECT *
FROM Event
WHERE administrator.id = ?1
  AND FUNCTION('unaccent', LOWER(description)) LIKE FUNCTION('unaccent', LOWER('%' ||? 2 || '%'))