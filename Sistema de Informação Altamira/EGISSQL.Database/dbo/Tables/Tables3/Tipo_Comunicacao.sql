CREATE TABLE [dbo].[Tipo_Comunicacao] (
    [cd_tipo_comunicacao]     INT          NOT NULL,
    [nm_tipo_comunicacao]     VARCHAR (30) NOT NULL,
    [sg_tipo_comunicacao]     CHAR (10)    NOT NULL,
    [cd_usuario]              INT          NOT NULL,
    [dt_usuario]              DATETIME     NOT NULL,
    [ic_pad_tipo_comunicacao] CHAR (1)     NULL,
    CONSTRAINT [PK_Tipo_Comunicacao] PRIMARY KEY CLUSTERED ([cd_tipo_comunicacao] ASC) WITH (FILLFACTOR = 90)
);

