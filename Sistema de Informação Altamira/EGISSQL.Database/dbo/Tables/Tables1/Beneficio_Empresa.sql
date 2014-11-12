CREATE TABLE [dbo].[Beneficio_Empresa] (
    [cd_beneficio_empresa]     INT          NOT NULL,
    [nm_beneficio_empresa]     VARCHAR (40) NULL,
    [sg_beneficio_empresa]     CHAR (10)    NULL,
    [vl_beneficio_empresa]     MONEY        NULL,
    [qt_beneficio_empresa]     FLOAT (53)   NULL,
    [pc_beneficio_empresa]     FLOAT (53)   NULL,
    [ic_dia_beneficio_empresa] CHAR (1)     NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    CONSTRAINT [PK_Beneficio_Empresa] PRIMARY KEY CLUSTERED ([cd_beneficio_empresa] ASC) WITH (FILLFACTOR = 90)
);

