﻿CREATE TABLE [dbo].[CONTRN] (
    [CONCOD]             SMALLINT       NOT NULL,
    [CONULTMOV]          INT            NULL,
    [CONULTPED]          INT            NULL,
    [CONULTNOT]          INT            NULL,
    [CONULTREC]          INT            NULL,
    [CONULTBOR]          INT            NULL,
    [CONTJD]             SMALLMONEY     NULL,
    [CONULFLUX]          INT            NULL,
    [CONULRECC]          INT            NULL,
    [CONULREDI]          INT            NULL,
    [CONULPEDC]          INT            NULL,
    [CONULRIR]           INT            NULL,
    [CONULTNOT1]         INT            NULL,
    [CONULEPRO]          INT            NULL,
    [CONULPEDI]          INT            NULL,
    [CONULCOTA]          INT            NULL,
    [CONULTTMP1]         DECIMAL (14)   NULL,
    [CONTROLE]           INT            NULL,
    [CONNFPSNF]          INT            NULL,
    [CONNFMSNF]          INT            NULL,
    [CONNFDSNF]          INT            NULL,
    [CONULTCV]           SMALLINT       NULL,
    [CONULTCT]           SMALLINT       NULL,
    [CONULTAT]           SMALLINT       NULL,
    [CONULCVD]           INT            NULL,
    [CONULTPC]           INT            NULL,
    [CONULGLF]           INT            NULL,
    [CONULTORDFAB]       INT            NULL,
    [CONULTPRGPRO]       INT            NULL,
    [CONULBAROF]         INT            NULL,
    [CONNFE]             CHAR (1)       NULL,
    [CONGUIA]            INT            NULL,
    [CONULCliEx]         DECIMAL (14)   NULL,
    [CONBenEnvValDias]   SMALLINT       NULL,
    [CONULTEMB]          INT            NULL,
    [CONULTPROESP]       INT            NULL,
    [CONTULTOPRom]       INT            NULL,
    [ConUltVei]          INT            NULL,
    [ConPathDrwOV]       VARCHAR (1000) NULL,
    [ConPathArqOV]       VARCHAR (1000) NULL,
    [ConUltDupRec]       INT            NULL,
    [ConUltCaCpg]        INT            NULL,
    [ConEmlCCOOrcamento] CHAR (200)     NULL,
    PRIMARY KEY CLUSTERED ([CONCOD] ASC)
);

