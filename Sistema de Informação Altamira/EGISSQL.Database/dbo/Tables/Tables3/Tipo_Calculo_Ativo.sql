CREATE TABLE [dbo].[Tipo_Calculo_Ativo] (
    [cd_tipo_calculo_ativo]     INT          NOT NULL,
    [nm_tipo_calculo_ativo]     VARCHAR (30) COLLATE SQL_Latin1_General_CP1250_CI_AS NULL,
    [sg_tipo_calculo_ativo]     CHAR (10)    COLLATE SQL_Latin1_General_CP1250_CI_AS NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    [cd_ordem_tipo_calculo]     INT          NULL,
    [ic_pad_tipo_calculo_ativo] CHAR (1)     NULL,
    CONSTRAINT [pk_tipo_calculo_ativo] PRIMARY KEY CLUSTERED ([cd_tipo_calculo_ativo] ASC) WITH (FILLFACTOR = 90)
);

