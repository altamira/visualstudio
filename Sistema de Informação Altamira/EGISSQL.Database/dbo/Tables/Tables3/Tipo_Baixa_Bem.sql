CREATE TABLE [dbo].[Tipo_Baixa_Bem] (
    [cd_tipo_baixa_bem]     INT          NOT NULL,
    [nm_tipo_baixa_bem]     VARCHAR (40) NULL,
    [sg_tipo_baixa_bem]     CHAR (10)    NULL,
    [ic_pad_tipo_baixa_bem] CHAR (1)     NULL,
    [cd_usuario]            INT          NULL,
    [dt_usuario]            DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Baixa_Bem] PRIMARY KEY CLUSTERED ([cd_tipo_baixa_bem] ASC) WITH (FILLFACTOR = 90)
);

