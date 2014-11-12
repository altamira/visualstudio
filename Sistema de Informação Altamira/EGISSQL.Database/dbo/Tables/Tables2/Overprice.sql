CREATE TABLE [dbo].[Overprice] (
    [cd_overprice]     INT          NOT NULL,
    [nm_overprice]     VARCHAR (40) NULL,
    [sg_overprice]     CHAR (10)    NULL,
    [pc_overprice]     FLOAT (53)   NULL,
    [nm_obs_overprice] VARCHAR (40) NULL,
    [cd_usuario]       INT          NULL,
    [dt_usuario]       DATETIME     NULL,
    CONSTRAINT [PK_Overprice] PRIMARY KEY CLUSTERED ([cd_overprice] ASC) WITH (FILLFACTOR = 90)
);

