-- CONSULTAS SQL - NIVEL BÁSICO (Continuación)
-- Base de datos: Sistema de Gestión Académica
-- PostgreSQL

-- ============================================================================
-- SECCIÓN 1: FILTRADO Y SELECCIÓN (Continuación)
-- ============================================================================

--26. Mostrar los estudiantes cuya edad esté entre 20 y 23 años (ambos inclusive).
SELECT Nombre, Apellido, Edad
FROM Estudiantes
WHERE Edad BETWEEN 20 AND 23;

--27. Mostrar las asignaturas que NO sean del segundo semestre.
SELECT Nombre, Semestre, Creditos
FROM Asignaturas
WHERE Semestre != 2;

--28. Mostrar los estudiantes que NO tienen 'Martinez' como apellido.
SELECT Nombre, Apellido
FROM Estudiantes
WHERE Apellido NOT LIKE '%Martinez%';

--29. Mostrar todas las asignaturas del primer o tercer semestre.
SELECT Nombre, Semestre
FROM Asignaturas
WHERE Semestre IN (1, 3);

--30. Mostrar las matrículas con nota numérica menor a 5.
SELECT Matricula, IDAsignatura, NotaNumerica
FROM Matriculas
WHERE NotaNumerica < 5;

--31. Mostrar los profesores cuyo nombre tiene exactamente 5 caracteres.
SELECT Nombre, Apellido
FROM Profesores
WHERE LENGTH(Nombre) = 5;

--32. Mostrar las asignaturas cuyo nombre contiene la palabra 'Anatomía'.
SELECT Nombre, Creditos
FROM Asignaturas
WHERE Nombre LIKE '%Anatomía%';

-- ============================================================================
-- SECCIÓN 2: ORDENACIÓN Y LIMITACIÓN
-- ============================================================================

--33. Mostrar los 5 estudiantes más jóvenes.
SELECT Nombre, Apellido, Edad
FROM Estudiantes
ORDER BY Edad ASC
LIMIT 5;

--34. Mostrar todas las asignaturas ordenadas por créditos de mayor a menor.
SELECT Nombre, Creditos
FROM Asignaturas
ORDER BY Creditos DESC;

--35. Mostrar los estudiantes ordenados alfabéticamente por apellido y luego por nombre.
SELECT Apellido, Nombre, Edad
FROM Estudiantes
ORDER BY Apellido, Nombre;

--36. Mostrar las 3 asignaturas con menos créditos.
SELECT Nombre, Creditos
FROM Asignaturas
ORDER BY Creditos ASC
LIMIT 3;

--37. Mostrar las matrículas ordenadas por fecha de matriculación, de la más reciente a la más antigua.
SELECT Matricula, IDAsignatura, FechaMatriculacion
FROM Matriculas
ORDER BY FechaMatriculacion DESC;

--38. Mostrar las asignaturas ordenadas por semestre y luego por nombre alfabéticamente.
SELECT Semestre, Nombre, Creditos
FROM Asignaturas
ORDER BY Semestre, Nombre;

-- ============================================================================
-- SECCIÓN 3: FUNCIONES DE AGREGACIÓN
-- ============================================================================

--39. Contar cuántas asignaturas hay en total.
SELECT COUNT(*) AS TotalAsignaturas
FROM Asignaturas;

--40. Calcular la nota más alta registrada en las matrículas.
SELECT MAX(NotaNumerica) AS NotaMasAlta
FROM Matriculas;

--41. Calcular la nota más baja registrada en las matrículas.
SELECT MIN(NotaNumerica) AS NotaMasBaja
FROM Matriculas;

--42. Calcular la suma total de créditos de todas las asignaturas.
SELECT SUM(Creditos) AS TotalCreditos
FROM Asignaturas;

--43. Calcular la edad promedio de los estudiantes (redondeado a 1 decimal).
SELECT ROUND(AVG(Edad), 1) AS EdadPromedio
FROM Estudiantes;

--44. Contar cuántas matrículas hay en total.
SELECT COUNT(*) AS TotalMatriculas
FROM Matriculas;

--45. Calcular cuántos semestres diferentes hay en las asignaturas.
SELECT COUNT(DISTINCT Semestre) AS SemestresDistintos
FROM Asignaturas;

--46. Contar cuántos profesores hay registrados.
SELECT COUNT(*) AS TotalProfesores
FROM Profesores;

-- ============================================================================
-- SECCIÓN 4: GROUP BY Y HAVING
-- ============================================================================

--47. Mostrar cuántos estudiantes hay de cada edad.
SELECT Edad, COUNT(*) AS NumeroEstudiantes
FROM Estudiantes
GROUP BY Edad
ORDER BY Edad;

--48. Mostrar el número de asignaturas por semestre.
SELECT Semestre, COUNT(*) AS NumeroAsignaturas
FROM Asignaturas
GROUP BY Semestre
ORDER BY Semestre;

--49. Calcular la nota promedio por asignatura.
SELECT IDAsignatura, ROUND(AVG(NotaNumerica), 2) AS NotaPromedio
FROM Matriculas
GROUP BY IDAsignatura
ORDER BY NotaPromedio DESC;

--50. Mostrar solo las edades que tienen más de 2 estudiantes.
SELECT Edad, COUNT(*) AS NumeroEstudiantes
FROM Estudiantes
GROUP BY Edad
HAVING COUNT(*) > 2;

--51. Mostrar las asignaturas (por ID) donde la nota promedio sea mayor a 6.
SELECT IDAsignatura, ROUND(AVG(NotaNumerica), 2) AS NotaPromedio
FROM Matriculas
GROUP BY IDAsignatura
HAVING AVG(NotaNumerica) > 6;

--52. Contar cuántas matrículas hay por cada número de matrícula.
SELECT Matricula, COUNT(*) AS AsignaturasMatriculadas
FROM Matriculas
GROUP BY Matricula
ORDER BY AsignaturasMatriculadas DESC;

--53. Mostrar los semestres que tienen al menos 3 asignaturas.
SELECT Semestre, COUNT(*) AS NumeroAsignaturas
FROM Asignaturas
GROUP BY Semestre
HAVING COUNT(*) >= 3;

-- ============================================================================
-- SECCIÓN 5: FUNCIONES DE TEXTO
-- ============================================================================

--54. Mostrar los nombres de estudiantes en minúsculas.
SELECT LOWER(Nombre) AS NombreMinusculas, LOWER(Apellido) AS ApellidoMinusculas
FROM Estudiantes;

--55. Mostrar los nombres de asignaturas con la primera letra de cada palabra en mayúscula.
SELECT INITCAP(Nombre) AS NombreFormateado
FROM Asignaturas;

--56. Concatenar nombre y apellido de los estudiantes separados por un espacio.
SELECT CONCAT(Nombre, ' ', Apellido) AS NombreCompleto
FROM Estudiantes;

--57. Mostrar los primeros 5 caracteres del nombre de cada asignatura.
SELECT Nombre, SUBSTRING(Nombre, 1, 5) AS NombreCorto
FROM Asignaturas;

--58. Reemplazar los espacios por guiones bajos en los nombres de las asignaturas.
SELECT Nombre, REPLACE(Nombre, ' ', '_') AS NombreSinEspacios
FROM Asignaturas;

--59. Eliminar espacios en blanco al inicio y final de los correos electrónicos de estudiantes.
SELECT CorreoElectronico, TRIM(CorreoElectronico) AS CorreoLimpio
FROM Estudiantes;

--60. Mostrar la longitud (número de caracteres) del nombre de cada profesor.
SELECT Nombre, LENGTH(Nombre) AS LongitudNombre
FROM Profesores;

--61. Concatenar apellido y nombre de profesores en formato "Apellido, Nombre".
SELECT CONCAT(Apellido, ', ', Nombre) AS NombreFormateado
FROM Profesores;

-- ============================================================================
-- SECCIÓN 6: FUNCIONES DE FECHA
-- ============================================================================

--62. Extraer el año de las fechas de matriculación.
SELECT Matricula, FechaMatriculacion, EXTRACT(YEAR FROM FechaMatriculacion) AS Año
FROM Matriculas;

--63. Extraer el mes de las fechas de matriculación.
SELECT Matricula, FechaMatriculacion, EXTRACT(MONTH FROM FechaMatriculacion) AS Mes
FROM Matriculas;

--64. Extraer el día de las fechas de matriculación.
SELECT Matricula, FechaMatriculacion, EXTRACT(DAY FROM FechaMatriculacion) AS Dia
FROM Matriculas;

--65. Mostrar las matrículas del mes de enero (cualquier año).
SELECT *
FROM Matriculas
WHERE EXTRACT(MONTH FROM FechaMatriculacion) = 1;

--66. Calcular cuántos días han pasado desde cada matriculación hasta hoy.
SELECT Matricula, FechaMatriculacion, CURRENT_DATE - FechaMatriculacion AS DiasDesdeMatricula
FROM Matriculas;

--67. Formatear la fecha de matriculación como 'DD/MM/YYYY'.
SELECT Matricula, TO_CHAR(FechaMatriculacion, 'DD/MM/YYYY') AS FechaFormateada
FROM Matriculas;

--68. Mostrar las matrículas del año 2023.
SELECT *
FROM Matriculas
WHERE EXTRACT(YEAR FROM FechaMatriculacion) = 2023;

--69. Calcular la antigüedad de cada matriculación en meses.
SELECT Matricula, FechaMatriculacion, 
       EXTRACT(YEAR FROM AGE(CURRENT_DATE, FechaMatriculacion)) * 12 + 
       EXTRACT(MONTH FROM AGE(CURRENT_DATE, FechaMatriculacion)) AS MesesDesdeMatricula
FROM Matriculas;

-- ============================================================================
-- SECCIÓN 7: OPERACIONES MATEMÁTICAS
-- ============================================================================

--70. Calcular cuántas horas de estudio se requieren si cada crédito equivale a 30 horas.
SELECT Nombre, Creditos, Creditos * 30 AS HorasEstudio
FROM Asignaturas;

--71. Calcular el porcentaje que representa cada nota sobre 10 (nota * 10).
SELECT Matricula, IDAsignatura, NotaNumerica, NotaNumerica * 10 AS Porcentaje
FROM Matriculas;

--72. Redondear las notas numéricas al entero más cercano.
SELECT Matricula, NotaNumerica, ROUND(NotaNumerica) AS NotaRedondeada
FROM Matriculas;

--73. Calcular la raíz cuadrada de los créditos de cada asignatura (redondeado a 2 decimales).
SELECT Nombre, Creditos, ROUND(SQRT(Creditos), 2) AS RaizCreditos
FROM Asignaturas;

--74. Calcular el cuadrado de las edades de los estudiantes.
SELECT Nombre, Edad, POWER(Edad, 2) AS EdadAlCuadrado
FROM Estudiantes;

--75. Calcular el valor absoluto de la diferencia entre cada nota y 5.
SELECT Matricula, NotaNumerica, ABS(NotaNumerica - 5) AS DiferenciaConCinco
FROM Matriculas;

--76. Calcular cuántos ECTS totales cursaría un estudiante si se matricula de todas las asignaturas del primer semestre.
SELECT SUM(Creditos) AS CreditosPrimerSemestre
FROM Asignaturas
WHERE Semestre = 1;

-- ============================================================================
-- SECCIÓN 8: EXPRESIONES CONDICIONALES (CASE)
-- ============================================================================

--77. Clasificar a los estudiantes como 'Joven' (<=21), 'Adulto' (22-25) o 'Mayor' (>25).
SELECT Nombre, Apellido, Edad,
    CASE 
        WHEN Edad <= 21 THEN 'Joven'
        WHEN Edad <= 25 THEN 'Adulto'
        ELSE 'Mayor'
    END AS CategoriaEdad
FROM Estudiantes;

--78. Clasificar las notas como 'Suspenso' (<5), 'Aprobado' (5-6.9), 'Notable' (7-8.9) o 'Sobresaliente' (>=9).
SELECT Matricula, IDAsignatura, NotaNumerica,
    CASE 
        WHEN NotaNumerica < 5 THEN 'Suspenso'
        WHEN NotaNumerica < 7 THEN 'Aprobado'
        WHEN NotaNumerica < 9 THEN 'Notable'
        ELSE 'Sobresaliente'
    END AS Calificacion
FROM Matriculas;

--79. Clasificar las asignaturas por carga de trabajo: 'Ligera' (<4 créditos), 'Media' (4-6) o 'Pesada' (>6).
SELECT Nombre, Creditos,
    CASE 
        WHEN Creditos < 4 THEN 'Ligera'
        WHEN Creditos <= 6 THEN 'Media'
        ELSE 'Pesada'
    END AS CargaTrabajo
FROM Asignaturas;

--80. Indicar si cada estudiante es 'Par' o 'Impar' según su edad.
SELECT Nombre, Apellido, Edad,
    CASE 
        WHEN Edad % 2 = 0 THEN 'Par'
        ELSE 'Impar'
    END AS ParidadEdad
FROM Estudiantes;

--81. Aplicar una bonificación del 15% a los créditos de asignaturas del primer semestre y 10% al resto.
SELECT Nombre, Creditos,
    CASE 
        WHEN Semestre = 1 THEN ROUND(Creditos * 1.15, 2)
        ELSE ROUND(Creditos * 1.10, 2)
    END AS CreditosConBonificacion
FROM Asignaturas;

--82. Clasificar matrículas por antigüedad: 'Reciente' (<180 días) o 'Antigua' (>=180 días).
SELECT Matricula, FechaMatriculacion,
    CASE 
        WHEN CURRENT_DATE - FechaMatriculacion < 180 THEN 'Reciente'
        ELSE 'Antigua'
    END AS Antiguedad
FROM Matriculas;

--83. Mostrar si el nombre de cada asignatura es 'Corto' (<=15 caracteres) o 'Largo' (>15 caracteres).
SELECT Nombre,
    CASE 
        WHEN LENGTH(Nombre) <= 15 THEN 'Corto'
        ELSE 'Largo'
    END AS LongitudNombre
FROM Asignaturas;

-- ============================================================================
-- SECCIÓN 9: CONSULTAS COMBINADAS
-- ============================================================================

--84. Mostrar estudiantes mayores de 22 años ordenados por edad descendente, limitado a 3 resultados.
SELECT Nombre, Apellido, Edad
FROM Estudiantes
WHERE Edad > 22
ORDER BY Edad DESC
LIMIT 3;

--85. Contar cuántas asignaturas hay en cada semestre y mostrar solo los que tengan más de 2 asignaturas.
SELECT Semestre, COUNT(*) AS NumeroAsignaturas
FROM Asignaturas
GROUP BY Semestre
HAVING COUNT(*) > 2
ORDER BY Semestre;

--86. Calcular la nota promedio general de todos los estudiantes y redondearla a 2 decimales.
SELECT ROUND(AVG(NotaNumerica), 2) AS NotaPromedioGeneral
FROM Matriculas;

--87. Mostrar las asignaturas con más de 4 créditos, ordenadas alfabéticamente.
SELECT Nombre, Creditos
FROM Asignaturas
WHERE Creditos > 4
ORDER BY Nombre;

--88. Contar cuántos estudiantes tienen cada apellido (solo mostrar apellidos con más de 1 estudiante).
SELECT Apellido, COUNT(*) AS NumeroEstudiantes
FROM Estudiantes
GROUP BY Apellido
HAVING COUNT(*) > 1
ORDER BY NumeroEstudiantes DESC;

--89. Mostrar las matrículas con nota >= 7, ordenadas por nota de mayor a menor.
SELECT Matricula, IDAsignatura, NotaNumerica
FROM Matriculas
WHERE NotaNumerica >= 7
ORDER BY NotaNumerica DESC;

--90. Calcular cuántos créditos en promedio tienen las asignaturas de cada semestre.
SELECT Semestre, ROUND(AVG(Creditos), 2) AS PromedioCreditos
FROM Asignaturas
GROUP BY Semestre
ORDER BY Semestre;
