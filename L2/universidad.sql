-- CONSULTAS SQL - JOINS Y SUBCONSULTAS (Continuación)
-- Base de datos: Universidad
-- PostgreSQL

-- ============================================================================
-- SECCIÓN 1: INNER JOINS BÁSICOS
-- ============================================================================

--33. Listar el nombre de todos los estudiantes con el nombre de las asignaturas en las que están matriculados y el nombre del profesor.
-- Explicación: Unimos 4 tablas para conectar estudiante -> matrícula -> asignatura -> profesor.
SELECT E.Nombre AS Estudiante, E.Apellido, A.Nombre AS Asignatura, P.Nombre AS Profesor, P.Apellido AS ApellidoProfesor
FROM Estudiantes AS E
INNER JOIN Matriculas AS M ON E.Matricula = M.Matricula
INNER JOIN Asignaturas AS A ON M.IDAsignatura = A.IDAsignatura
INNER JOIN Profesores AS P ON A.IDProfesor = P.IDProfesor
ORDER BY E.Apellido, E.Nombre;

--34. Mostrar el nombre del estudiante, asignatura y fecha de matriculación de todos los que se matricularon en 2023.
-- Explicación: Filtramos por año después de hacer JOIN entre estudiantes, matrículas y asignaturas.
SELECT E.Nombre, E.Apellido, A.Nombre AS Asignatura, M.FechaMatriculacion
FROM Estudiantes AS E
INNER JOIN Matriculas AS M ON E.Matricula = M.Matricula
INNER JOIN Asignaturas AS A ON M.IDAsignatura = A.IDAsignatura
WHERE EXTRACT(YEAR FROM M.FechaMatriculacion) = 2023
ORDER BY M.FechaMatriculacion;

--35. Listar profesores (nombre y departamento) junto con el número de asignaturas que imparten.
-- Explicación: Agrupamos por profesor después de JOIN con asignaturas para contar.
SELECT P.Nombre, P.Apellido, P.Departamento, COUNT(A.IDAsignatura) AS NumAsignaturas
FROM Profesores AS P
INNER JOIN Asignaturas AS A ON P.IDProfesor = A.IDProfesor
GROUP BY P.IDProfesor, P.Nombre, P.Apellido, P.Departamento
ORDER BY NumAsignaturas DESC;

--36. Mostrar asignaturas del tercer semestre con el nombre del profesor que las imparte.
-- Explicación: JOIN simple con filtro por semestre.
SELECT A.Nombre AS Asignatura, A.Creditos, P.Nombre AS Profesor, P.Apellido
FROM Asignaturas AS A
INNER JOIN Profesores AS P ON A.IDProfesor = P.IDProfesor
WHERE A.Semestre = 3
ORDER BY A.Nombre;

--37. Listar estudiantes (nombre y correo) que están matriculados en asignaturas de más de 4 créditos.
-- Explicación: JOIN con filtro en créditos, DISTINCT para evitar duplicados.
SELECT DISTINCT E.Nombre, E.Apellido, E.CorreoElectronico
FROM Estudiantes AS E
INNER JOIN Matriculas AS M ON E.Matricula = M.Matricula
INNER JOIN Asignaturas AS A ON M.IDAsignatura = A.IDAsignatura
WHERE A.Creditos > 4
ORDER BY E.Apellido;

-- ============================================================================
-- SECCIÓN 2: JOINS CON AGREGACIONES
-- ============================================================================

--38. Calcular la nota media de cada estudiante junto con el número de asignaturas matriculadas.
-- Explicación: Agrupamos por estudiante, calculamos promedio de notas y contamos asignaturas.
SELECT E.Matricula, E.Nombre, E.Apellido, 
       ROUND(AVG(M.NotaNumerica), 2) AS NotaMedia,
       COUNT(M.IDAsignatura) AS NumAsignaturas
FROM Estudiantes AS E
INNER JOIN Matriculas AS M ON E.Matricula = M.Matricula
GROUP BY E.Matricula, E.Nombre, E.Apellido
ORDER BY NotaMedia DESC;

--39. Mostrar el total de créditos cursados por cada estudiante agrupado por semestre.
-- Explicación: Sumamos créditos por estudiante y semestre para ver la carga académica.
SELECT E.Nombre, E.Apellido, A.Semestre, SUM(A.Creditos) AS TotalCreditos
FROM Estudiantes AS E
INNER JOIN Matriculas AS M ON E.Matricula = M.Matricula
INNER JOIN Asignaturas AS A ON M.IDAsignatura = A.IDAsignatura
GROUP BY E.Matricula, E.Nombre, E.Apellido, A.Semestre
ORDER BY E.Apellido, A.Semestre;

--40. Calcular el número de estudiantes y la nota promedio para cada asignatura.
-- Explicación: Agrupamos por asignatura para obtener estadísticas de cada una.
SELECT A.Nombre AS Asignatura, 
       COUNT(DISTINCT M.Matricula) AS NumEstudiantes,
       ROUND(AVG(M.NotaNumerica), 2) AS NotaPromedio
FROM Asignaturas AS A
INNER JOIN Matriculas AS M ON A.IDAsignatura = M.IDAsignatura
GROUP BY A.IDAsignatura, A.Nombre
ORDER BY NotaPromedio DESC;

--41. Mostrar departamentos con el número total de asignaturas y promedio de créditos por asignatura.
-- Explicación: Agrupamos por departamento a través de profesores y asignaturas.
SELECT P.Departamento, 
       COUNT(A.IDAsignatura) AS TotalAsignaturas,
       ROUND(AVG(A.Creditos), 2) AS PromedioCreditos
FROM Profesores AS P
INNER JOIN Asignaturas AS A ON P.IDProfesor = A.IDProfesor
GROUP BY P.Departamento
ORDER BY TotalAsignaturas DESC;

--42. Listar estudiantes con más de 15 créditos matriculados en total.
-- Explicación: Sumamos créditos por estudiante y filtramos con HAVING.
SELECT E.Nombre, E.Apellido, SUM(A.Creditos) AS TotalCreditos
FROM Estudiantes AS E
INNER JOIN Matriculas AS M ON E.Matricula = M.Matricula
INNER JOIN Asignaturas AS A ON M.IDAsignatura = A.IDAsignatura
GROUP BY E.Matricula, E.Nombre, E.Apellido
HAVING SUM(A.Creditos) > 15
ORDER BY TotalCreditos DESC;

-- ============================================================================
-- SECCIÓN 3: LEFT JOIN Y OUTER JOINS
-- ============================================================================

--43. Mostrar todos los estudiantes con el número de asignaturas en las que están matriculados (incluso si no están matriculados en ninguna).
-- Explicación: LEFT JOIN permite incluir estudiantes sin matrículas, COUNT contará 0 para ellos.
SELECT E.Matricula, E.Nombre, E.Apellido, COUNT(M.IDAsignatura) AS NumAsignaturas
FROM Estudiantes AS E
LEFT JOIN Matriculas AS M ON E.Matricula = M.Matricula
GROUP BY E.Matricula, E.Nombre, E.Apellido
ORDER BY NumAsignaturas DESC;

--44. Listar todas las asignaturas con el número de estudiantes matriculados (incluso asignaturas sin estudiantes).
-- Explicación: LEFT JOIN desde asignaturas para incluir las que no tienen matrículas.
SELECT A.Nombre AS Asignatura, A.Creditos, COUNT(M.Matricula) AS NumEstudiantes
FROM Asignaturas AS A
LEFT JOIN Matriculas AS M ON A.IDAsignatura = M.IDAsignatura
GROUP BY A.IDAsignatura, A.Nombre, A.Creditos
ORDER BY NumEstudiantes DESC;

--45. Mostrar todos los profesores con el número de estudiantes que tienen en total (incluso profesores sin estudiantes).
-- Explicación: Dos LEFT JOIN para incluir profesores sin asignaturas o sin estudiantes.
SELECT P.Nombre, P.Apellido, P.Departamento, COUNT(DISTINCT M.Matricula) AS NumEstudiantes
FROM Profesores AS P
LEFT JOIN Asignaturas AS A ON P.IDProfesor = A.IDProfesor
LEFT JOIN Matriculas AS M ON A.IDAsignatura = M.IDAsignatura
GROUP BY P.IDProfesor, P.Nombre, P.Apellido, P.Departamento
ORDER BY NumEstudiantes DESC;

--46. Listar estudiantes con su nota media, incluyendo aquellos sin notas (mostrar NULL o 0).
-- Explicación: LEFT JOIN para incluir todos los estudiantes, COALESCE para manejar NULL.
SELECT E.Nombre, E.Apellido, 
       COALESCE(ROUND(AVG(M.NotaNumerica), 2), 0) AS NotaMedia
FROM Estudiantes AS E
LEFT JOIN Matriculas AS M ON E.Matricula = M.Matricula
GROUP BY E.Matricula, E.Nombre, E.Apellido
ORDER BY NotaMedia DESC;

--47. Mostrar asignaturas del segundo curso que no tienen ningún estudiante matriculado.
-- Explicación: LEFT JOIN con filtro NULL para encontrar asignaturas sin matrículas.
SELECT A.Nombre AS Asignatura, A.Creditos, A.Semestre
FROM Asignaturas AS A
LEFT JOIN Matriculas AS M ON A.IDAsignatura = M.IDAsignatura
WHERE A.Curso = 2 AND M.Matricula IS NULL;

-- ============================================================================
-- SECCIÓN 4: SUBCONSULTAS EN WHERE
-- ============================================================================

--48. Mostrar estudiantes cuya edad es mayor que la edad promedio de todos los estudiantes.
-- Explicación: Subconsulta calcula edad promedio, WHERE filtra estudiantes que la superan.
SELECT Nombre, Apellido, Edad
FROM Estudiantes
WHERE Edad > (
    SELECT AVG(Edad)
    FROM Estudiantes
)
ORDER BY Edad DESC;

--49. Listar asignaturas impartidas por profesores del departamento de 'Ingenieria'.
-- Explicación: Subconsulta obtiene IDs de profesores de Ingeniería, WHERE filtra asignaturas.
SELECT Nombre, Creditos, Semestre
FROM Asignaturas
WHERE IDProfesor IN (
    SELECT IDProfesor
    FROM Profesores
    WHERE Departamento = 'Ingenieria'
)
ORDER BY Nombre;

--50. Mostrar estudiantes que tienen al menos una nota superior a 8.
-- Explicación: Subconsulta encuentra matrículas con nota > 8, IN filtra estudiantes.
SELECT DISTINCT E.Nombre, E.Apellido, E.CorreoElectronico
FROM Estudiantes AS E
WHERE E.Matricula IN (
    SELECT Matricula
    FROM Matriculas
    WHERE NotaNumerica > 8
)
ORDER BY E.Apellido;

--51. Listar profesores cuyo salario es superior al salario promedio de su departamento.
-- Explicación: Subconsulta correlacionada compara cada profesor con el promedio de su departamento.
SELECT P1.Nombre, P1.Apellido, P1.Departamento, P1.Salario
FROM Profesores AS P1
WHERE P1.Salario > (
    SELECT AVG(P2.Salario)
    FROM Profesores AS P2
    WHERE P2.Departamento = P1.Departamento
)
ORDER BY P1.Departamento, P1.Salario DESC;

--52. Mostrar asignaturas con nota promedio superior a 7.
-- Explicación: Subconsulta agrupa por asignatura y calcula promedio, filtro en el HAVING.
SELECT A.Nombre AS Asignatura, A.Creditos
FROM Asignaturas AS A
WHERE A.IDAsignatura IN (
    SELECT M.IDAsignatura
    FROM Matriculas AS M
    GROUP BY M.IDAsignatura
    HAVING AVG(M.NotaNumerica) > 7
)
ORDER BY A.Nombre;

-- ============================================================================
-- SECCIÓN 5: SUBCONSULTAS CON NOT IN / NOT EXISTS
-- ============================================================================

--53. Listar estudiantes que NO están matriculados en ninguna asignatura.
-- Explicación: NOT IN con subconsulta de matrículas para excluir estudiantes matriculados.
SELECT Nombre, Apellido, CorreoElectronico
FROM Estudiantes
WHERE Matricula NOT IN (
    SELECT DISTINCT Matricula
    FROM Matriculas
);

--54. Mostrar asignaturas que no tienen ningún estudiante con nota inferior a 5.
-- Explicación: NOT IN excluye asignaturas donde haya algún suspenso.
SELECT A.Nombre AS Asignatura, A.Creditos
FROM Asignaturas AS A
WHERE A.IDAsignatura NOT IN (
    SELECT IDAsignatura
    FROM Matriculas
    WHERE NotaNumerica < 5
)
AND A.IDAsignatura IN (
    SELECT DISTINCT IDAsignatura
    FROM Matriculas
)
ORDER BY A.Nombre;

--55. Listar profesores que NO imparten asignaturas en el primer semestre.
-- Explicación: NOT IN con subconsulta de profesores que SÍ imparten en semestre 1.
SELECT P.Nombre, P.Apellido, P.Departamento
FROM Profesores AS P
WHERE P.IDProfesor NOT IN (
    SELECT DISTINCT A.IDProfesor
    FROM Asignaturas AS A
    WHERE A.Semestre = 1
);

--56. Mostrar estudiantes que NO han obtenido ninguna nota superior a 9.
-- Explicación: NOT IN para excluir estudiantes con notas excelentes.
SELECT E.Nombre, E.Apellido, E.Edad
FROM Estudiantes AS E
WHERE E.Matricula NOT IN (
    SELECT Matricula
    FROM Matriculas
    WHERE NotaNumerica > 9
);

--57. Listar asignaturas del segundo curso que ningún estudiante mayor de 23 años ha cursado.
-- Explicación: Doble condición NOT IN, filtrado por curso y edad.
SELECT A.Nombre AS Asignatura, A.Creditos
FROM Asignaturas AS A
WHERE A.Curso = 2
AND A.IDAsignatura NOT IN (
    SELECT M.IDAsignatura
    FROM Matriculas AS M
    INNER JOIN Estudiantes AS E ON M.Matricula = E.Matricula
    WHERE E.Edad > 23
);

-- ============================================================================
-- SECCIÓN 6: SUBCONSULTAS CORRELACIONADAS
-- ============================================================================

--58. Mostrar estudiantes con nota superior al promedio de su misma edad.
-- Explicación: Subconsulta correlacionada compara cada estudiante con el promedio de su grupo de edad.
SELECT E.Nombre, E.Apellido, E.Edad, ROUND(AVG(M.NotaNumerica), 2) AS NotaMedia
FROM Estudiantes AS E
INNER JOIN Matriculas AS M ON E.Matricula = M.Matricula
GROUP BY E.Matricula, E.Nombre, E.Apellido, E.Edad
HAVING AVG(M.NotaNumerica) > (
    SELECT AVG(M2.NotaNumerica)
    FROM Matriculas AS M2
    INNER JOIN Estudiantes AS E2 ON M2.Matricula = E2.Matricula
    WHERE E2.Edad = E.Edad
)
ORDER BY E.Edad, NotaMedia DESC;

--59. Listar asignaturas cuyo número de matriculados es mayor que el promedio de matriculados por asignatura.
-- Explicación: Comparamos cada asignatura con el promedio general de matriculados.
SELECT A.Nombre AS Asignatura, COUNT(M.Matricula) AS NumMatriculados
FROM Asignaturas AS A
INNER JOIN Matriculas AS M ON A.IDAsignatura = M.IDAsignatura
GROUP BY A.IDAsignatura, A.Nombre
HAVING COUNT(M.Matricula) > (
    SELECT AVG(num_estudiantes)
    FROM (
        SELECT COUNT(*) AS num_estudiantes
        FROM Matriculas
        GROUP BY IDAsignatura
    ) AS subquery
)
ORDER BY NumMatriculados DESC;

--60. Mostrar profesores que imparten más asignaturas que el promedio de asignaturas por profesor.
-- Explicación: Subconsulta calcula promedio de asignaturas, comparamos cada profesor.
SELECT P.Nombre, P.Apellido, P.Departamento, COUNT(A.IDAsignatura) AS NumAsignaturas
FROM Profesores AS P
INNER JOIN Asignaturas AS A ON P.IDProfesor = A.IDProfesor
GROUP BY P.IDProfesor, P.Nombre, P.Apellido, P.Departamento
HAVING COUNT(A.IDAsignatura) > (
    SELECT AVG(num_asignaturas)
    FROM (
        SELECT COUNT(*) AS num_asignaturas
        FROM Asignaturas
        GROUP BY IDProfesor
    ) AS subquery
)
ORDER BY NumAsignaturas DESC;

-- ============================================================================
-- SECCIÓN 7: ANÁLISIS POR DEPARTAMENTO Y CURSO
-- ============================================================================

--61. Mostrar el número de estudiantes únicos por departamento (a través de asignaturas matriculadas).
-- Explicación: JOIN de 4 tablas para conectar departamento con estudiantes.
SELECT P.Departamento, COUNT(DISTINCT M.Matricula) AS NumEstudiantes
FROM Profesores AS P
INNER JOIN Asignaturas AS A ON P.IDProfesor = A.IDProfesor
INNER JOIN Matriculas AS M ON A.IDAsignatura = M.IDAsignatura
GROUP BY P.Departamento
ORDER BY NumEstudiantes DESC;

--62. Calcular la nota media por curso académico.
-- Explicación: Agrupamos por curso para ver el rendimiento en cada nivel.
SELECT A.Curso, ROUND(AVG(M.NotaNumerica), 2) AS NotaMediaCurso
FROM Asignaturas AS A
INNER JOIN Matriculas AS M ON A.IDAsignatura = M.IDAsignatura
GROUP BY A.Curso
ORDER BY A.Curso;

--63. Mostrar el departamento con mayor número total de créditos impartidos.
-- Explicación: Sumamos créditos por departamento y ordenamos descendente.
SELECT P.Departamento, SUM(A.Creditos) AS TotalCreditos
FROM Profesores AS P
INNER JOIN Asignaturas AS A ON P.IDProfesor = A.IDProfesor
GROUP BY P.Departamento
ORDER BY TotalCreditos DESC
LIMIT 1;

--64. Listar cursos con el número de asignaturas y el total de créditos disponibles.
-- Explicación: Agrupamos por curso para ver la oferta académica en cada nivel.
SELECT A.Curso, 
       COUNT(A.IDAsignatura) AS NumAsignaturas,
       SUM(A.Creditos) AS TotalCreditos
FROM Asignaturas AS A
GROUP BY A.Curso
ORDER BY A.Curso;

--65. Calcular el promedio de edad de estudiantes por departamento (según asignaturas matriculadas).
-- Explicación: JOIN completo para relacionar estudiantes con departamentos.
SELECT P.Departamento, ROUND(AVG(E.Edad), 1) AS EdadPromedio
FROM Profesores AS P
INNER JOIN Asignaturas AS A ON P.IDProfesor = A.IDProfesor
INNER JOIN Matriculas AS M ON A.IDAsignatura = M.IDAsignatura
INNER JOIN Estudiantes AS E ON M.Matricula = E.Matricula
GROUP BY P.Departamento
ORDER BY EdadPromedio DESC;

-- ============================================================================
-- SECCIÓN 8: ANÁLISIS DE RENDIMIENTO
-- ============================================================================

--66. Mostrar asignaturas con más del 50% de estudiantes con nota >= 7 (notable o superior).
-- Explicación: Calculamos porcentaje de aprobados con buena nota por asignatura.
SELECT A.Nombre AS Asignatura,
       COUNT(M.Matricula) AS TotalEstudiantes,
       COUNT(CASE WHEN M.NotaNumerica >= 7 THEN 1 END) AS EstudiantesNotable,
       ROUND(COUNT(CASE WHEN M.NotaNumerica >= 7 THEN 1 END)::NUMERIC / COUNT(M.Matricula) * 100, 2) AS PorcentajeNotable
FROM Asignaturas AS A
INNER JOIN Matriculas AS M ON A.IDAsignatura = M.IDAsignatura
GROUP BY A.IDAsignatura, A.Nombre
HAVING COUNT(CASE WHEN M.NotaNumerica >= 7 THEN 1 END)::NUMERIC / COUNT(M.Matricula) > 0.5
ORDER BY PorcentajeNotable DESC;

--67. Listar estudiantes con todas sus notas aprobadas (sin ningún suspenso).
-- Explicación: NOT IN excluye estudiantes con alguna nota < 5.
SELECT E.Nombre, E.Apellido, COUNT(M.IDAsignatura) AS NumAsignaturas
FROM Estudiantes AS E
INNER JOIN Matriculas AS M ON E.Matricula = M.Matricula
WHERE E.Matricula NOT IN (
    SELECT Matricula
    FROM Matriculas
    WHERE NotaNumerica < 5
)
GROUP BY E.Matricula, E.Nombre, E.Apellido
ORDER BY NumAsignaturas DESC;

--68. Mostrar la asignatura más difícil (con la nota media más baja) de cada semestre.
-- Explicación: Window function con partición por semestre para rankear.
SELECT Semestre, Asignatura, NotaMedia
FROM (
    SELECT A.Semestre, A.Nombre AS Asignatura, 
           ROUND(AVG(M.NotaNumerica), 2) AS NotaMedia,
           RANK() OVER (PARTITION BY A.Semestre ORDER BY AVG(M.NotaNumerica) ASC) AS ranking
    FROM Asignaturas AS A
    INNER JOIN Matriculas AS M ON A.IDAsignatura = M.IDAsignatura
    GROUP BY A.Semestre, A.Nombre
) AS ranked
WHERE ranking = 1
ORDER BY Semestre;

--69. Calcular la tasa de aprobados (porcentaje de notas >= 5) por departamento.
-- Explicación: Contamos aprobados vs total por departamento.
SELECT P.Departamento,
       COUNT(M.Matricula) AS TotalMatriculas,
       COUNT(CASE WHEN M.NotaNumerica >= 5 THEN 1 END) AS Aprobados,
       ROUND(COUNT(CASE WHEN M.NotaNumerica >= 5 THEN 1 END)::NUMERIC / COUNT(M.Matricula) * 100, 2) AS TasaAprobados
FROM Profesores AS P
INNER JOIN Asignaturas AS A ON P.IDProfesor = A.IDProfesor
INNER JOIN Matriculas AS M ON A.IDAsignatura = M.IDAsignatura
GROUP BY P.Departamento
ORDER BY TasaAprobados DESC;

-- ============================================================================
-- SECCIÓN 9: CONSULTAS AVANZADAS
-- ============================================================================

--70. Encontrar estudiantes que están matriculados en todas las asignaturas de un determinado profesor.
-- Explicación: Comparamos número de asignaturas del profesor con las que tiene el estudiante.
SELECT E.Nombre, E.Apellido, P.Nombre AS Profesor, P.Apellido AS ApellidoProfesor
FROM Estudiantes AS E
INNER JOIN Matriculas AS M ON E.Matricula = M.Matricula
INNER JOIN Asignaturas AS A ON M.IDAsignatura = A.IDAsignatura
INNER JOIN Profesores AS P ON A.IDProfesor = P.IDProfesor
GROUP BY E.Matricula, E.Nombre, E.Apellido, P.IDProfesor, P.Nombre, P.Apellido
HAVING COUNT(DISTINCT A.IDAsignatura) = (
    SELECT COUNT(*)
    FROM Asignaturas AS A2
    WHERE A2.IDProfesor = P.IDProfesor
);

--71. Mostrar pares de estudiantes que comparten todas sus asignaturas.
-- Explicación: Self-join para encontrar estudiantes con exactamente las mismas matrículas.
SELECT DISTINCT E1.Nombre AS Estudiante1, E1.Apellido AS Apellido1,
                E2.Nombre AS Estudiante2, E2.Apellido AS Apellido2,
                COUNT(DISTINCT M1.IDAsignatura) AS AsignaturasCompartidas
FROM Estudiantes AS E1
INNER JOIN Estudiantes AS E2 ON E1.Matricula < E2.Matricula
INNER JOIN Matriculas AS M1 ON E1.Matricula = M1.Matricula
INNER JOIN Matriculas AS M2 ON E2.Matricula = M2.Matricula AND M1.IDAsignatura = M2.IDAsignatura
GROUP BY E1.Matricula, E1.Nombre, E1.Apellido, E2.Matricula, E2.Nombre, E2.Apellido
HAVING COUNT(DISTINCT M1.IDAsignatura) = (SELECT COUNT(*) FROM Matriculas WHERE Matricula = E1.Matricula)
   AND COUNT(DISTINCT M1.IDAsignatura) = (SELECT COUNT(*) FROM Matriculas WHERE Matricula = E2.Matricula);

--72. Listar asignaturas donde la diferencia entre la nota más alta y más baja sea superior a 3 puntos.
-- Explicación: Calculamos rango (max - min) por asignatura y filtramos.
SELECT A.Nombre AS Asignatura,
       MAX(M.NotaNumerica) AS NotaMaxima,
       MIN(M.NotaNumerica) AS NotaMinima,
       MAX(M.NotaNumerica) - MIN(M.NotaNumerica) AS Rango
FROM Asignaturas AS A
INNER JOIN Matriculas AS M ON A.IDAsignatura = M.IDAsignatura
GROUP BY A.IDAsignatura, A.Nombre
HAVING MAX(M.NotaNumerica) - MIN(M.NotaNumerica) > 3
ORDER BY Rango DESC;

--73. Mostrar el ranking de los 3 mejores estudiantes por semestre (según nota media).
-- Explicación: Window function para rankear estudiantes dentro de cada semestre.
SELECT Semestre, Nombre, Apellido, NotaMedia, Ranking
FROM (
    SELECT A.Semestre, E.Nombre, E.Apellido,
           ROUND(AVG(M.NotaNumerica), 2) AS NotaMedia,
           RANK() OVER (PARTITION BY A.Semestre ORDER BY AVG(M.NotaNumerica) DESC) AS Ranking
    FROM Estudiantes AS E
    INNER JOIN Matriculas AS M ON E.Matricula = M.Matricula
    INNER JOIN Asignaturas AS A ON M.IDAsignatura = A.IDAsignatura
    GROUP BY A.Semestre, E.Matricula, E.Nombre, E.Apellido
) AS ranked
WHERE Ranking <= 3
ORDER BY Semestre, Ranking;

--74. Calcular la carga de trabajo de cada profesor (total de estudiantes en todas sus asignaturas).
-- Explicación: Contamos estudiantes únicos por profesor a través de sus asignaturas.
SELECT P.Nombre, P.Apellido, P.Departamento,
       COUNT(DISTINCT A.IDAsignatura) AS NumAsignaturas,
       COUNT(M.Matricula) AS TotalMatriculas,
       COUNT(DISTINCT M.Matricula) AS EstudiantesUnicos
FROM Profesores AS P
INNER JOIN Asignaturas AS A ON P.IDProfesor = A.IDProfesor
INNER JOIN Matriculas AS M ON A.IDAsignatura = M.IDAsignatura
GROUP BY P.IDProfesor, P.Nombre, P.Apellido, P.Departamento
ORDER BY TotalMatriculas DESC;

--75. Mostrar estudiantes que han mejorado su rendimiento (nota media del 2º semestre > 1er semestre).
-- Explicación: Comparamos promedios entre semestres para cada estudiante.
SELECT E.Nombre, E.Apellido,
       ROUND(AVG(CASE WHEN A.Semestre = 1 THEN M.NotaNumerica END), 2) AS NotaSemestre1,
       ROUND(AVG(CASE WHEN A.Semestre = 2 THEN M.NotaNumerica END), 2) AS NotaSemestre2
FROM Estudiantes AS E
INNER JOIN Matriculas AS M ON E.Matricula = M.Matricula
INNER JOIN Asignaturas AS A ON M.IDAsignatura = A.IDAsignatura
WHERE A.Semestre IN (1, 2)
GROUP BY E.Matricula, E.Nombre, E.Apellido
HAVING AVG(CASE WHEN A.Semestre = 2 THEN M.NotaNumerica END) > 
       AVG(CASE WHEN A.Semestre = 1 THEN M.NotaNumerica END)
ORDER BY (AVG(CASE WHEN A.Semestre = 2 THEN M.NotaNumerica END) - 
          AVG(CASE WHEN A.Semestre = 1 THEN M.NotaNumerica END)) DESC;
