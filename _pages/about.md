---
permalink: /
title: ""
excerpt: ""
author_profile: true
redirect_from: 
  - /about/
  - /about.html
---

{% if site.google_scholar_stats_use_cdn %}
{% assign gsDataBaseUrl = "https://cdn.jsdelivr.net/gh/" | append: site.repository | append: "@" %}
{% else %}
{% assign gsDataBaseUrl = "https://raw.githubusercontent.com/" | append: site.repository | append: "/" %}
{% endif %}
{% assign url = gsDataBaseUrl | append: "google-scholar-stats/gs_data_shieldsio.json" %}

<span class='anchor' id='about-me'></span>

I am a PhD student at Fudan University. My research interests include AI security and AI safety, with a focus on the safety of text-to-image generation models.

My publications have received in total <a href='https://scholar.google.com/citations?user=AIxm9uAAAAAJ'>google scholar citations <strong><span id='total_cit'>11</span></strong></a> (You can also use google scholar badge <a href='https://scholar.google.com/citations?user=AIxm9uAAAAAJ'><img src="https://img.shields.io/endpoint?url={{ url | url_encode }}&logo=Google%20Scholar&labelColor=f6f6f6&color=9cf&style=flat&label=citations"></a>).


# 📖 Educations

- <span class="edu-date">Sep 2025 – Present</span> — **Fudan University**, Ph.D. in Computer Science · Zhuobo Program
  - Research focus: model interpretability and AI safety
- <span class="edu-date">Sep 2021 – Jun 2025</span> — **Fudan University**, B.Eng. in Software Engineering · School of Software
  - GPA: 3.78 / 4.00, Major rank: 2 / 105

# 🔥 News
- To be updated.

# 💻 Internships
- To be updated.

# 📝 Publications 

<ul class="pub-list">
  <li class="pub-item">
    <div class="pub-title">Adaptive Concept Erasure in Diffusion Models via Sparse Steering Vectors <span class="pub-tag">KDD 2027</span></div>
    <div class="pub-authors"><strong>Guanxu Chen</strong>, Huming Qiu, Mi Zhang, Zhenxing Qian, Yun Xiong, Xiaoyang Wang, Zhibo Zhang, Min Yang</div>
    <div class="pub-links">
      <!-- Add the Website link here when available. -->
      <!-- Add the Paper link here when available. -->
    </div>
  </li>
  <li class="pub-item">
    <div class="pub-title"><a href="https://arxiv.org/abs/2411.10329">Safe Text-to-Image Generation: Simply Sanitize the Prompt Embedding</a> <span class="pub-tag">arXiv 2024</span></div>
    <div class="pub-authors">Huming Qiu, <strong>Guanxu Chen</strong>, Mi Zhang, Xiaohan Zhang, Xiaoyu You, Min Yang</div>
    <div class="pub-links">
      <a href="https://arxiv.org/abs/2411.10329">[Website]</a>
      <a href="https://arxiv.org/pdf/2411.10329">[Paper]</a>
      <!-- Add a Hugging Face link here when available. -->
      <span class="pub-citations">Citations: <span class="show_paper_citations" data="AIxm9uAAAAAJ:9yKSN-GCB0IC"></span></span>
    </div>
  </li>
</ul>

# 🎖 Honors and Awards

- **Shanghai Outstanding Graduate** — Shanghai
- **Undergraduate Honors Certificate** — Fudan University
