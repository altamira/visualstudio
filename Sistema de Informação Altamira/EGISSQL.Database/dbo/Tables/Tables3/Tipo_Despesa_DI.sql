CREATE TABLE [dbo].[Tipo_Despesa_DI] (
    [cd_tipo_despesa_di]     INT          NOT NULL,
    [nm_tipo_despesa_di]     VARCHAR (30) NULL,
    [sg_tipo_despesa_di]     CHAR (10)    NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    [ic_pad_tipo_despesa_di] CHAR (1)     NULL,
    CONSTRAINT [PK_Tipo_Despesa_DI] PRIMARY KEY CLUSTERED ([cd_tipo_despesa_di] ASC) WITH (FILLFACTOR = 90)
);

