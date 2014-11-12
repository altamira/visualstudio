CREATE TABLE [dbo].[Tipo_Movto_Comp_Especial] (
    [cd_tipo_movto_comp_esp]   INT          NOT NULL,
    [nm_tipo_movto_comp_esp]   VARCHAR (40) NULL,
    [sg_tipo_movto_comp_esp]   CHAR (10)    NULL,
    [ic_fim_producao_comp_esp] CHAR (1)     NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Movto_Comp_Especial] PRIMARY KEY CLUSTERED ([cd_tipo_movto_comp_esp] ASC) WITH (FILLFACTOR = 90)
);

