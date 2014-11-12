CREATE TABLE [dbo].[Curso] (
    [cd_curso]               INT          NOT NULL,
    [nm_curso]               VARCHAR (40) NULL,
    [sg_curso]               CHAR (10)    NULL,
    [ic_ativo_curso]         CHAR (1)     NULL,
    [ds_curso]               TEXT         NULL,
    [cd_grupo_preco_produto] INT          NULL,
    [qt_base_hora_curso]     FLOAT (53)   NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    CONSTRAINT [PK_Curso] PRIMARY KEY CLUSTERED ([cd_curso] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Curso_Grupo_Preco_Produto] FOREIGN KEY ([cd_grupo_preco_produto]) REFERENCES [dbo].[Grupo_Preco_Produto] ([cd_grupo_preco_produto])
);

