CREATE TABLE [dbo].[Tipo_Prestacao_Conta] (
    [cd_tipo_prestacao]     INT          NOT NULL,
    [nm_tipo_prestacao]     VARCHAR (40) NULL,
    [sg_tipo_prestacao]     CHAR (10)    NULL,
    [cd_usuario]            INT          NULL,
    [dt_usuario]            DATETIME     NULL,
    [ic_pad_tipo_prestacao] CHAR (1)     NULL,
    [cd_conta]              INT          NULL,
    CONSTRAINT [PK_Tipo_Prestacao_Conta] PRIMARY KEY CLUSTERED ([cd_tipo_prestacao] ASC) WITH (FILLFACTOR = 90)
);

