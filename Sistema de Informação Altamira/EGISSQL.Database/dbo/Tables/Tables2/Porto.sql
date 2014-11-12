CREATE TABLE [dbo].[Porto] (
    [cd_porto]          INT          NOT NULL,
    [nm_porto]          VARCHAR (30) NOT NULL,
    [sg_porto]          CHAR (5)     NOT NULL,
    [cd_pais]           INT          NULL,
    [cd_siscomex_porto] INT          NOT NULL,
    [cd_usuario]        INT          NULL,
    [dt_usuario]        DATETIME     NULL,
    [cd_estado]         INT          NULL,
    CONSTRAINT [PK_Porto] PRIMARY KEY CLUSTERED ([cd_porto] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Porto_Estado] FOREIGN KEY ([cd_estado]) REFERENCES [dbo].[Estado] ([cd_estado]),
    CONSTRAINT [FK_Porto_Pais] FOREIGN KEY ([cd_pais]) REFERENCES [dbo].[Pais] ([cd_pais])
);

