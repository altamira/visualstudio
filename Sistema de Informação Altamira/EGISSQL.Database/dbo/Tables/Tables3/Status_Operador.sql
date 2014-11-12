CREATE TABLE [dbo].[Status_Operador] (
    [cd_status_operador]      INT          NOT NULL,
    [nm_status_operador]      VARCHAR (40) NULL,
    [sg_status_operador]      CHAR (10)    NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    [ic_tipo_status_operador] CHAR (1)     NULL,
    CONSTRAINT [PK_Status_Operador] PRIMARY KEY CLUSTERED ([cd_status_operador] ASC) WITH (FILLFACTOR = 90)
);

