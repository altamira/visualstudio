CREATE TABLE [dbo].[Info_Gerencial] (
    [cd_info_gerencial]       INT          NOT NULL,
    [nm_info_gerencial]       VARCHAR (40) NOT NULL,
    [sg_info_gerencial]       CHAR (15)    NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    [ic_ativo_info_gerencial] CHAR (1)     NULL,
    [ic_tipo_info_gerencial]  CHAR (1)     NULL,
    CONSTRAINT [PK_Info_Gerencial] PRIMARY KEY CLUSTERED ([cd_info_gerencial] ASC) WITH (FILLFACTOR = 90)
);

