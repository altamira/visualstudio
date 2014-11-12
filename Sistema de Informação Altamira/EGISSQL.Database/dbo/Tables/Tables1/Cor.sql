CREATE TABLE [dbo].[Cor] (
    [cd_grupo_produto] INT          NULL,
    [cd_cor]           INT          NOT NULL,
    [nm_cor]           VARCHAR (40) NOT NULL,
    [sg_cor]           CHAR (10)    NULL,
    [pc_acresc_cor]    FLOAT (53)   NULL,
    [cd_usuario]       INT          NULL,
    [dt_usuario]       DATETIME     NULL,
    [vl_hexa_cor]      CHAR (20)    NULL,
    [cd_cor_texto]     INT          NULL,
    CONSTRAINT [PK_Cor] PRIMARY KEY CLUSTERED ([cd_cor] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Cor_Grupo_Produto] FOREIGN KEY ([cd_grupo_produto]) REFERENCES [dbo].[Grupo_Produto] ([cd_grupo_produto])
);

