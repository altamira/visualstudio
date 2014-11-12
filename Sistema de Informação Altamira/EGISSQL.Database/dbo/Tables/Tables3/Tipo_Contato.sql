CREATE TABLE [dbo].[Tipo_Contato] (
    [cd_tipo_contato]     INT          NOT NULL,
    [nm_tipo_contato]     VARCHAR (40) NULL,
    [sg_tipo_contato]     CHAR (10)    NULL,
    [ic_pad_tipo_contato] CHAR (1)     NULL,
    [cd_usuario]          INT          NULL,
    [dt_usuario]          DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Contato] PRIMARY KEY CLUSTERED ([cd_tipo_contato] ASC) WITH (FILLFACTOR = 90)
);

