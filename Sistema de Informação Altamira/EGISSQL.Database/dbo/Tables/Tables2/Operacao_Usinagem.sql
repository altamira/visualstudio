CREATE TABLE [dbo].[Operacao_Usinagem] (
    [cd_operacao_usinagem] INT          NOT NULL,
    [nm_operacao_usinagem] VARCHAR (40) NULL,
    [sg_operacao_usinagem] CHAR (15)    NULL,
    [cd_bloco_prog_cnc]    INT          NULL,
    [cd_usuario]           INT          NULL,
    [dt_usuario]           DATETIME     NULL,
    [ic_rosca_usinagem]    CHAR (1)     NULL,
    [ic_rasgo_placa]       CHAR (1)     NULL,
    CONSTRAINT [PK_Operacao_Usinagem] PRIMARY KEY CLUSTERED ([cd_operacao_usinagem] ASC) WITH (FILLFACTOR = 90)
);

