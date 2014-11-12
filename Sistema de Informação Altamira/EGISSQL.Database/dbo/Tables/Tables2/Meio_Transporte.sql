CREATE TABLE [dbo].[Meio_Transporte] (
    [cd_meio_transporte]          INT          NOT NULL,
    [nm_meio_transporte]          VARCHAR (40) NULL,
    [sg_meio_transporte]          CHAR (10)    NULL,
    [vl_meio_transporte]          FLOAT (53)   NULL,
    [dt_reajuste_meio_transporte] DATETIME     NULL,
    [nm_obs_meio_transporte]      VARCHAR (40) NULL,
    [cd_usuario]                  INT          NULL,
    [dt_usuario]                  DATETIME     NULL,
    CONSTRAINT [PK_Meio_Transporte] PRIMARY KEY CLUSTERED ([cd_meio_transporte] ASC) WITH (FILLFACTOR = 90)
);

