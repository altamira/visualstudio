CREATE TABLE [dbo].[Status_Maquina] (
    [cd_status_maquina]      INT          NOT NULL,
    [nm_status_maquina]      VARCHAR (40) NULL,
    [sg_status_maquina]      CHAR (15)    NULL,
    [ic_tipo_calculo_status] CHAR (1)     NULL,
    [cd_imagem]              INT          NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    [ic_operacao_maquina]    CHAR (1)     NULL,
    CONSTRAINT [PK_Status_Maquina] PRIMARY KEY CLUSTERED ([cd_status_maquina] ASC) WITH (FILLFACTOR = 90)
);

