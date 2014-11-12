CREATE TABLE [dbo].[Divisao_Regiao_Cidade] (
    [cd_pais]                   INT      NOT NULL,
    [cd_estado]                 INT      NOT NULL,
    [cd_cidade]                 INT      NOT NULL,
    [cd_regiao]                 INT      NOT NULL,
    [cd_divisao_regiao]         INT      NOT NULL,
    [ic_soma_divisao_regiao_ci] CHAR (1) NULL,
    [cd_usuario]                INT      NOT NULL,
    [dt_usuario]                DATETIME NOT NULL,
    CONSTRAINT [PK_Divisao_Regiao_Cidade] PRIMARY KEY CLUSTERED ([cd_pais] ASC, [cd_estado] ASC, [cd_cidade] ASC, [cd_regiao] ASC, [cd_divisao_regiao] ASC) WITH (FILLFACTOR = 90)
);

