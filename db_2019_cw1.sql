-- Q1:
SELECT personB.name, personA.dod
FROM   person AS personA JOIN person AS personB
	   ON personA.name = personB.mother
	   AND personA.dod IS NOT NULL
;

-- Q2:
SELECT   name
FROM     person
WHERE    gender = 'M'
EXCEPT
SELECT   father
FROM     person
ORDER BY name
;

-- Q3:
SELECT   name
FROM     person AS personA
WHERE    NOT EXISTS (SELECT gender
	  			     FROM   person
	                 EXCEPT
	  			     SELECT gender
	                 FROM   person AS personB
	                 WHERE  personA.name = personB.mother)
ORDER BY name
;

-- Q4:
SELECT   name, father, mother
FROM     person AS personA
WHERE    father IS NOT NULL
AND      mother IS NOT NULL
AND      dob <= ALL (SELECT dob
				     FROM   person AS personB
				     WHERE  personA.father = personB.father
				     AND    personA.mother = personB.mother)
ORDER BY name
;

-- Q5:
SELECT   SUBSTRING((name || ' ') FROM 1 FOR POSITION(' ' IN (name || ' '))-1) AS firstName,
	     COUNT(name) AS popularity
FROM     person
GROUP BY firstName
HAVING   COUNT(name) > 1
ORDER BY popularity DESC, firstName
;

-- Q6:
SELECT   parent.name,
	     COUNT(CASE WHEN child.dob >= '1940-01-01' AND child.dob < '1950-01-01' THEN child.name ELSE NULL END) AS forties,
	     COUNT(CASE WHEN child.dob >= '1950-01-01' AND child.dob < '1960-01-01' THEN child.name ELSE NULL END) AS fifties,
	     COUNT(CASE WHEN child.dob >= '1960-01-01' AND child.dob < '1970-01-01' THEN child.name ELSE NULL END) AS sixies
FROM     person AS parent JOIN person AS child
	     ON  parent.name = child.mother
	     OR  parent.name = child.father
GROUP BY parent.name
HAVING   COUNT(parent.name) > 1
ORDER BY parent.name
;

-- Q7:
SELECT   father, mother, name AS child,
	     RANK() OVER(PARTITION BY father, mother ORDER BY dob) AS born
FROM     person
WHERE    father IS NOT NULL
AND      mother IS NOT NULL
ORDER BY father, mother, born
;

-- Q8:
SELECT   father, mother,
	     ROUND(100.0*SUM(CASE WHEN gender = 'M' THEN 1 ELSE 0 END)/COUNT(gender), 0) AS male
FROM     person
WHERE    father IS NOT NULL
AND      mother IS NOT NULL
GROUP BY father, mother
ORDER BY father, mother
;

