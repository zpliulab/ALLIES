## 2026.04.20 make the code and data into CellLand

"""PCA and plotting helpers for PCA.ipynb."""

from __future__ import annotations

import os
from typing import Optional

import matplotlib.pyplot as plt
import numpy as np
from matplotlib.ticker import MultipleLocator
from mpl_toolkits.mplot3d import Axes3D  # noqa: F401 — registers 3d projection
from scipy import interpolate
from sklearn.decomposition import PCA

__all__ = [
    "pca",
    "highdim_pca",
    "plot_pca",
    "plot_3d_scatter",
    "plot_pca_1D",
    "plot_pca_1d_scatter_with_curve",
    "plot_3d_energy_projection",
]


def pca(data, n_dim):
    """
    pca is O(D^3)
    :param data: (n_samples, n_features(D))
    :param n_dim: target dimensions
    :return: (n_samples, n_dim)
    """
    data = data - np.mean(data, axis=0, keepdims=True)

    cov = np.dot(data.T, data)

    eig_values, eig_vector = np.linalg.eig(cov)
    indexs_ = np.argsort(-eig_values)[:n_dim]
    picked_eig_vector = eig_vector[:, indexs_]
    data_ndim = np.dot(data, picked_eig_vector)
    return data_ndim


def highdim_pca(data, n_dim):
    """
    when n_features(D) >> n_samples(N), highdim_pca is O(N^3)
    :param data: (n_samples, n_features)
    :param n_dim: target dimensions
    :return: (n_samples, n_dim)
    """
    N = data.shape[0]
    data = data - np.mean(data, axis=0, keepdims=True)

    Ncov = np.dot(data, data.T)

    Neig_values, Neig_vector = np.linalg.eig(Ncov)
    indexs_ = np.argsort(-Neig_values)[:n_dim]
    Npicked_eig_values = Neig_values[indexs_]
    Npicked_eig_vector = Neig_vector[:, indexs_]

    picked_eig_vector = np.dot(data.T, Npicked_eig_vector)
    picked_eig_vector = picked_eig_vector / (N * Npicked_eig_values.reshape(-1, n_dim)) ** 0.5

    data_ndim = np.dot(data, picked_eig_vector)
    return data_ndim


def plot_pca(
    X,
    Y,
    s=10,
    title="sklearn_PCA",
    figsize=(5, 4),
    cmap="viridis",
    dpi=300,
    save_path=False,
):
    """
    PCA on X and scatter plot.
    :param X: feature matrix (2D)
    :param Y: class labels or color values
    :param title: plot title
    :param figsize: figure size
    :param cmap: colormap name
    """
    pca_model = PCA(n_components=2)
    X_pca = pca_model.fit_transform(X)

    plt.figure(figsize=figsize)
    sc = plt.scatter(
        X_pca[:, 0], X_pca[:, 1], c=Y, s=s, cmap=cmap, alpha=0.7, edgecolors="k", linewidths=0.2
    )
    plt.xlabel("Principal Component 1", fontsize=12)
    plt.ylabel("Principal Component 2", fontsize=12)
    plt.colorbar(sc)
    plt.tight_layout()
    if save_path:
        plt.savefig(save_path, dpi=dpi, bbox_inches="tight", transparent=True)
    plt.show()


def plot_3d_scatter(
    xx,
    yy,
    zz,
    color=None,
    title="3D Scatter plot",
    cmap="viridis",
    figsize=(6, 5),
    save_path=None,
    dpi=300,
    transparent=True,
):
    """
    3D scatter plot; optional high-res PNG with transparent background.

    :param xx: x coordinates (1D)
    :param yy: y coordinates (1D)
    :param zz: z coordinates (1D)
    :param color: color mapping (e.g. zz or class labels), default None
    :param title: plot title
    :param cmap: colormap
    :param figsize: figure size
    :param save_path: output path (e.g. 'scatter3d.png')
    :param dpi: resolution
    :param transparent: transparent background
    """
    fig = plt.figure(figsize=figsize)
    ax = fig.add_subplot(111, projection="3d")
    if color is None:
        color = zz
    sc = ax.scatter3D(xx, yy, zz, c=color, cmap=cmap, s=12, alpha=0.85)
    fig.colorbar(sc, ax=ax)
    ax.set_title(title, fontsize=14, fontweight="bold")
    ax.set_xlabel("X", fontsize=12)
    ax.set_ylabel("Y", fontsize=12)
    ax.set_zlabel("Z", fontsize=12)
    plt.tight_layout()
    if save_path:
        plt.savefig(save_path, dpi=dpi, bbox_inches="tight", transparent=transparent)
    plt.show()


def plot_pca_1D(
    X,
    Y,
    Z,
    s=10,
    title="sklearn_PCA 1D",
    figsize=(5, 4),
    cmap="viridis",
    dpi=300,
    save_path=False,
):
    sklearn_pca1 = PCA(n_components=1)
    data_2d21 = sklearn_pca1.fit_transform(X)

    plt.figure(figsize=figsize)
    sc = plt.scatter(
        data_2d21[:, 0], Z, c=Y, s=s, cmap=cmap, alpha=0.7, edgecolors="k", linewidths=0.2
    )

    plt.title("sklearn_PCA 1D")
    plt.xlabel("Principal Component 1")
    plt.ylabel("Energy")
    plt.colorbar(sc)

    plt.tight_layout()
    if save_path:
        plt.savefig(save_path, dpi=dpi, bbox_inches="tight", transparent=True)
    plt.show()


def plot_pca_1d_scatter_with_curve(
    X,
    Z,
    Y=None,
    scatter_size=18,
    curve_color="red",
    curve_label="Linear Interp.",
    title="PCA 1D Projection with Energy Curve",
    xlabel="Principal Component 1",
    ylabel="Energy",
    cbar_label="Label",
    figsize=(5.5, 4),
    cmap="viridis",
    dpi=300,
    save_path: Optional[str] = None,
):
    """
    X: features (n_samples, n_features)
    Z: energy / target (n_samples,)
    Y: optional labels for coloring (n_samples,)
    """
    pca_model = PCA(n_components=1)
    pc1 = pca_model.fit_transform(X).ravel()

    idx_sort = np.argsort(pc1)
    pc1_sorted = pc1[idx_sort]
    Z_sorted = np.array(Z)[idx_sort]

    xnew = np.linspace(pc1_sorted[0], pc1_sorted[-1], 150)
    f = interpolate.interp1d(pc1_sorted, Z_sorted, kind="linear")
    ynew = f(xnew)

    plt.figure(figsize=figsize)
    ax = plt.gca()

    if Y is not None:
        sc = plt.scatter(
            pc1,
            Z,
            c=Y,
            s=scatter_size,
            cmap=cmap,
            alpha=0.78,
            edgecolors="k",
            linewidths=0.22,
            zorder=5,
        )
        cbar = plt.colorbar(sc)
        cbar.set_label(cbar_label, fontsize=12)
        cbar.ax.tick_params(labelsize=11)
        cbar.outline.set_visible(False)
    else:
        plt.scatter(
            pc1,
            Z,
            s=scatter_size,
            color="#0072B2",
            alpha=0.78,
            edgecolors="k",
            linewidths=0.22,
            zorder=5,
        )

    plt.plot(xnew, ynew, color="white", linewidth=2.2, zorder=10)

    plt.xlabel(xlabel, fontsize=13)
    plt.ylabel(ylabel, fontsize=13)
    plt.xticks(fontsize=11)
    plt.yticks(fontsize=11)
    ax.grid(True, linestyle="--", alpha=0.36, zorder=0)
    ax.spines["right"].set_visible(False)
    ax.spines["top"].set_visible(False)
    ax.set_facecolor("white")
    ax.xaxis.set_major_locator(MultipleLocator((pc1.max() - pc1.min()) / 6))
    ax.yaxis.set_major_locator(MultipleLocator((max(Z) - min(Z)) / 6))

    plt.legend(fontsize=12, loc="best", frameon=False)
    plt.tight_layout()
    if save_path:
        parent = os.path.dirname(save_path)
        if parent:
            os.makedirs(parent, exist_ok=True)
        plt.savefig(save_path, dpi=dpi, bbox_inches="tight", transparent=True)
    plt.show()


def plot_3d_energy_projection(
    xx,
    yy,
    zz,
    Y,
    save_path=None,
    figsize=(8, 5.6),
    main_cmap="Blues",
    proj_cmap="Set3",
    s=30,
    alpha=0.7,
    pad=0.13,
    shrink=0.7,
    aspect=25,
    z_proj_offset=10,
    title=None,
    xlabel="Principal Component 1",
    ylabel="Principal Component 2",
    zlabel="Energy",
    show=True,
):
    """
    3D energy scatter with floor projection colored by class Y.

    Args:
        xx, yy, zz: 1D coordinates of main points
        Y: 1D class labels for floor projection colors
        save_path: png path or None
        figsize: figure size tuple
        main_cmap, proj_cmap: colormaps for main / projection points
        s: marker size
        alpha: opacity
        pad, shrink, aspect: colorbar kwargs
        z_proj_offset: floor is min(zz) minus this offset
        title, xlabel, ylabel, zlabel: axis labels
        show: call plt.show() if True
    """
    z0 = np.full_like(zz, zz.min() - abs(z_proj_offset))

    fig = plt.figure(figsize=figsize)
    ax = fig.add_subplot(111, projection="3d")

    im = ax.scatter3D(
        xx, yy, zz, c=zz, cmap=main_cmap, s=s, alpha=alpha, edgecolors="k", linewidths=0.2
    )
    ax.scatter3D(
        xx, yy, z0, c=Y, cmap=proj_cmap, s=s, alpha=alpha, edgecolors="k", linewidths=0.2
    )

    cb = fig.colorbar(im, ax=ax, pad=pad, shrink=shrink, aspect=aspect)
    cb.ax.tick_params(labelsize=11)

    if title is not None:
        ax.set_title(title, fontsize=16, fontweight="bold", pad=18)
    ax.set_xlabel(xlabel, fontsize=13, labelpad=10)
    ax.set_ylabel(ylabel, fontsize=13, labelpad=10)
    ax.set_zlabel(zlabel, fontsize=13, labelpad=10)
    ax.tick_params(labelsize=11)
    ax.grid(True, alpha=0.25)
    ax.set_facecolor("white")
    try:
        for spine in ax.spines.values():
            spine.set_visible(False)
    except Exception:
        pass

    plt.tight_layout()
    if save_path is not None:
        plt.savefig(save_path, dpi=300, bbox_inches="tight", transparent=True)
    if show:
        plt.show()
    else:
        plt.close()
