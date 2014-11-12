CREATE TABLE [dbo].[Beneficio] (
    [cd_beneficio]        INT          NOT NULL,
    [nm_beneficio]        VARCHAR (40) NULL,
    [ds_beneficio]        TEXT         NULL,
    [cd_usuario]          INT          NULL,
    [dt_usuario]          DATETIME     NULL,
    [cd_grupo_beneficio]  INT          NULL,
    [ic_padrao_beneficio] CHAR (1)     NULL,
    [ic_ativo_beneficio]  CHAR (1)     NULL,
    CONSTRAINT [PK_Beneficio] PRIMARY KEY CLUSTERED ([cd_beneficio] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Beneficio_Grupo_Beneficio] FOREIGN KEY ([cd_grupo_beneficio]) REFERENCES [dbo].[Grupo_Beneficio] ([cd_grupo_beneficio])
);

