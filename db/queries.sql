-- Consultas no sistema

-- 1) Recuperar todas as datas dos fornecimentos atrelados aos cursos dados a turmas de anos pares em uma aldeia X.
SELECT T.CURSO, T.ANO, F.PATROCINIO, TO_CHAR(F."DATA", 'DD/MM/YYYY') FROM FORNECIMENTO F
    JOIN FORNECIMENTO_CURSO FC ON F.PATROCINIO = FC.FORNECIMENTO
    JOIN TURMA T ON FC.CURSO = T.CURSO
    WHERE CAST(T.ANO AS INTEGER) % 2 = 0 AND T.ALDEIA = '(-0.7893, 21.4294)';

-- 2) Dado uma aldeia X recuperar quem foi o administrador que entrou em contato com o patrocinador que patrocinou o fornecimento dos projetos dos indígenas daquela aldeia e as datas de contato.
SELECT FC.NOME, TO_CHAR(C."DATA", 'DD/MM/YYYY') FROM INDIGENA I
    JOIN ALDEIA A ON I.ALDEIA = A."LOCAL"
    JOIN PROJETO P ON I.CPF = P.ALUNO
    JOIN FORNECIMENTO_PROJETO FP ON P.TITULO = FP.PROJETO
    JOIN FORNECIMENTO F ON FP.FORNECIMENTO = F.PATROCINIO
    JOIN PATROCINADOR PT ON F.PATROCINADOR = PT.CNPJ
    JOIN CONTATO C ON PT.CNPJ = C.EMPRESA
    JOIN ADMINISTRADOR ADM ON C.ADMINISTRADOR = ADM.CPF
    JOIN FUNCIONARIOS FC ON ADM.CPF = FC.CPF
    WHERE ALDEIA = '(-16.2350, 145.3170)';

-- 3) Descobrir todos os indígenas que participaram de todas as turmas de um certo professor (divisão relacional feita com agrupamento, usando a contagem de matérias necessárias)
SELECT DISTINCT I.NOME, "AT".ALUNO FROM ALUNO_TURMA "AT"
    JOIN INDIGENA I ON "AT".ALUNO = I.CPF
    JOIN TURMA T ON "AT".TURMA = T.ID
    WHERE T.ID IN (SELECT T.ID FROM TURMA T JOIN PROFESSOR P ON T.PROFESSOR = P.FUNCIONARIO WHERE P.FUNCIONARIO = '59203678149')
    GROUP BY "AT".ALUNO, I.NOME
    HAVING COUNT(*) = (SELECT COUNT(*) FROM TURMA T JOIN PROFESSOR P ON T.PROFESSOR = P.FUNCIONARIO WHERE P.FUNCIONARIO = '59203678149');

-- 4) Todos os materiais usados nos projetos e cursos em uma aldeia x
SELECT F.TIPO, T.CURSO, M.TIPO FROM MATERIAL M
    JOIN MATERIAL_FORNECIMENTO MF ON M.IMEI = MF.MATERIAL
    JOIN FORNECIMENTO F ON MF.FORNECIMENTO = F.PATROCINIO
    JOIN FORNECIMENTO_CURSO FC ON FC.FORNECIMENTO = F.PATROCINIO
    JOIN TURMA T ON T.CURSO = FC.CURSO
    WHERE T.ALDEIA = '(-16.2350, 145.3170)'
    UNION SELECT
    F.TIPO, P.TITULO, M.TIPO FROM ALDEIA A
    JOIN INDIGENA I ON A."LOCAL" = I.ALDEIA
    JOIN PROJETO P ON I.CPF = P.ALUNO
    JOIN FORNECIMENTO_PROJETO FP ON P.TITULO = FP.PROJETO
    JOIN FORNECIMENTO F ON FP.FORNECIMENTO = F.PATROCINIO
    JOIN MATERIAL_FORNECIMENTO MF ON F.PATROCINIO = MF.FORNECIMENTO
    JOIN MATERIAL M ON MF.MATERIAL = M.IMEI
    WHERE A."LOCAL" = '(-16.2350, 145.3170)';

-- 5) Selecione quantas turmas e projetos cada professor já teve em cada aldeia
SELECT F.NOME, T.ALDEIA, COUNT(*) FROM FUNCIONARIOS F
    JOIN PROFESSOR P ON F.CPF = P.FUNCIONARIO
    JOIN PROJETO PR ON P.FUNCIONARIO = PR.PROFESSOR
    JOIN TURMA T ON P.FUNCIONARIO = T.PROFESSOR
    GROUP BY T.ALDEIA, F.NOME ORDER BY F.NOME;