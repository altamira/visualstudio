CREATE TABLE [dbo].[Acessorio] (
    [cd_grupo_produto]          INT          NOT NULL,
    [cd_acessorio]              INT          NOT NULL,
    [nm_acessorio]              VARCHAR (40) NULL,
    [sg_acessorio]              CHAR (10)    NULL,
    [vl_acessorio]              FLOAT (53)   NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    [ic_tipo_calculo_acessorio] CHAR (1)     NULL,
    CONSTRAINT [PK_Acessorio] PRIMARY KEY CLUSTERED ([cd_grupo_produto] ASC, [cd_acessorio] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Acessorio_Grupo_Produto] FOREIGN KEY ([cd_grupo_produto]) REFERENCES [dbo].[Grupo_Produto] ([cd_grupo_produto])
);

