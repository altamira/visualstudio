CREATE TABLE [dbo].[Caracteristica_Produto] (
    [cd_caracteristica_produto]  INT          NOT NULL,
    [nm_caracteristica_produto]  VARCHAR (60) NULL,
    [nm_fantasia_caracteristica] VARCHAR (15) NULL,
    [ds_caracteristica_produto]  TEXT         NULL,
    [ic_calculo_caracteristica]  CHAR (1)     NULL,
    [cd_usuario]                 INT          NULL,
    [dt_usuario]                 DATETIME     NULL,
    CONSTRAINT [PK_Caracteristica_Produto] PRIMARY KEY CLUSTERED ([cd_caracteristica_produto] ASC) WITH (FILLFACTOR = 90)
);

