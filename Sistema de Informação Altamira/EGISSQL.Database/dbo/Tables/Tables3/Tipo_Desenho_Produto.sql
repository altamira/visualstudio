CREATE TABLE [dbo].[Tipo_Desenho_Produto] (
    [cd_tipo_desenho]     INT           NOT NULL,
    [nm_tipo_desenho]     VARCHAR (40)  NULL,
    [sg_tipo_desenho]     CHAR (10)     NULL,
    [nm_doc_tipo_desenho] VARCHAR (100) NULL,
    [nm_img_tipo_desenho] VARCHAR (100) NULL,
    [nm_obs_tipo_desenho] VARCHAR (40)  NULL,
    [cd_usuario]          INT           NULL,
    [dt_usuario]          DATETIME      NULL,
    CONSTRAINT [PK_Tipo_Desenho_Produto] PRIMARY KEY CLUSTERED ([cd_tipo_desenho] ASC) WITH (FILLFACTOR = 90)
);

